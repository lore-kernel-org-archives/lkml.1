Return-Path: <linux-kernel-owner+w=401wt.eu-S1751611AbXE2WLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611AbXE2WLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 18:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbXE2WLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 18:11:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:39120 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbXE2WLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 18:11:12 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: Tetsuo Handa <from-lsm@i-love.sakura.ne.jp>
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSMhook
Date: Wed, 30 May 2007 00:10:55 +0200
User-Agent: KMail/1.9.5
Cc: crispin@novell.com, cliffe@iinet.net.au, casey@schaufler-ca.com,
       mrmacman_g4@mac.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <653438.15244.qm@web36612.mail.mud.yahoo.com> <200705291907.29547.agruen@suse.de> <200705300547.AJG94871.SNTPGtMN@I-love.SAKURA.ne.jp>
In-Reply-To: <200705300547.AJG94871.SNTPGtMN@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705300010.55742.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 May 2007 22:47, Tetsuo Handa wrote:
> AppArmor can't determine which pathname (/tmp/public/file or
> /tmp/secret/file) was requested by touch command if bound mount is used in
> the following way 
> 
> # mkdir /tmp/public /tmp/secret
> # mount -t tmpfs none /tmp/public
> # mount --bind /tmp/public /tmp/secret
> # touch /tmp/public/file
> 
> because security_inode_create() doesn't receive vfsmount, can it?

I don't know what you are talking about -- the very first patch in the 
AppArmor series adds the vfsmount parameter to security_inode_create().

Andreas
