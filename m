Return-Path: <linux-kernel-owner+w=401wt.eu-S1757964AbZCZNO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964AbZCZNO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 09:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbZCZNOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 09:14:44 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:35459 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbZCZNOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 09:14:43 -0400
Date: Thu, 26 Mar 2009 07:14:25 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Pavel Machek <pavel@ucw.cz>
Cc: Miklos Szeredi <miklos@szeredi.hu>, serue@us.ibm.com, bfields@fieldses.org,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       ebiederm@xmission.com, linux-fsdevel@vger.kernel.org
Subject: Re: unprivileged mounts vs. rmdir (was: VFS, NFS security bug? ...)
Message-ID: <20090326131425.GB8014@parisc-linux.org>
References: <20090311232356.GP13540@fieldses.org> <20090312161047.GA15209@us.ibm.com> <517f3f820903121321sf6d2014q8165b925d5d44db7@mail.gmail.com> <20090313175848.GB27891@fieldses.org> <cfd18e0f0903141220u66230ceer22ef0cc6aed1d046@mail.gmail.com> <f44001920903160716i488e3642o869f626a5c3327d0@mail.gmail.com> <20090316163611.GB10959@fieldses.org> <20090316170433.GA2996@us.ibm.com> <E1Llk5q-0000kd-IR@pomaz-ex.szeredi.hu> <20090326124338.GA1466@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326124338.GA1466@ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 01:43:38PM +0100, Pavel Machek wrote:
> Well... traditionally if you have an open file or cwd inside mounted
> tree... that blocks unmount, right?
> 
> What will you do with processes that have open (deleted) files inside
> the mount? What about cwd?

umount -l ?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
