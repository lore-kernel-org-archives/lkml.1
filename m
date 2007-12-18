Return-Path: <linux-kernel-owner+w=401wt.eu-S1762976AbXLRCJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762976AbXLRCJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 21:09:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbXLRCJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 21:09:35 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41828 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbXLRCJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 21:09:34 -0500
Date: Mon, 17 Dec 2007 20:09:33 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       linux-fsdevel@vger.kernel.org,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] [RFC] Simple tamper-proof device filesystem.
Message-ID: <20071218020933.GA28745@sergelap.austin.ibm.com>
References: <20071216080441.435456586@I-love.SAKURA.ne.jp> <20071216080628.061470932@I-love.SAKURA.ne.jp> <200712161944.HEI26071.MOtOFLVHFSQFOJ@I-love.SAKURA.ne.jp> <200712161956.BJE32406.FOOHtQJLMFOSVF@I-love.SAKURA.ne.jp> <20071217194802.GA14156@sergelap.austin.ibm.com> <200712180003.lBI03N7F092396@www262.sakura.ne.jp> <20071218003955.GA27048@sergelap.austin.ibm.com> <476724E3.6060901@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476724E3.6060901@cs.columbia.edu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oren Laadan (orenl@cs.columbia.edu):
> 
> I hate to bring this again, but what if the admin in the container
> mounts an external file system (eg. nfs, usb, loop mount from a file,
> or via fuse), and that file system already has a device that we would
> like to ban inside that container ?

Miklos' user mount patches enforced that if !capable(CAP_MKNOD),
then mnt->mnt_flags |= MNT_NODEV.  So that's no problem.

But that's been pulled out of -mm! ?  Crap.

> Since anyway we will have to keep a white- (or black-) list of devices
> that are permitted in a container, and that list may change even change
> per container -- why not enforce the access control at the VFS layer ?
> It's safer in the long run.

By that you mean more along the lines of Pavel's patch than my whitelist
LSM, or you actually mean Tetsuo's filesystem (i assume you don't mean that
by 'vfs layer' :), or something different entirely?

thanks,
-serge
