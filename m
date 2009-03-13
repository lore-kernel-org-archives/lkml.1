Return-Path: <linux-kernel-owner+w=401wt.eu-S1759324AbZCMTAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759324AbZCMTAZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 15:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbZCMTAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 15:00:09 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:57599 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012AbZCMTAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 15:00:07 -0400
Date: Fri, 13 Mar 2009 14:00:02 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Igor Zhbanov <izh1979@gmail.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk, neilb@suse.de, Trond.Myklebust@netapp.com,
       David Howells <dhowells@redhat.com>, Andrew Morgan <morgan@kernel.org>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       SELinux <selinux@tycho.nsa.gov>
Subject: Re: =?utf-8?B?0J7RgtCy0LXRgjogVkZTLCBORlMg?=
	=?utf-8?Q?security_bug=3F_Shoul?=
	=?utf-8?Q?d?= CAP_MKNOD and CAP_LINUX_IMMUTABLE be added to
	CAP_FS_MASK?
Message-ID: <20090313190002.GA16025@us.ibm.com>
References: <f44001920903110553t52ce0ba7l4ba97213e1c51873@mail.gmail.com> <20090311232356.GP13540@fieldses.org> <20090312161047.GA15209@us.ibm.com> <517f3f820903121321sf6d2014q8165b925d5d44db7@mail.gmail.com> <20090313175848.GB27891@fieldses.org> <f44001920903131137j158c5f76y6a71b58ee964df77@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f44001920903131137j158c5f76y6a71b58ee964df77@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Igor Zhbanov (izh1979@gmail.com):
> But ordinary users can't create devices. It seems to me that in time
> of implementation of capabilities in kernel 2.4, capabilities related
> to filesystem was added first. And mark for them contains all above in
> header file. And when CAP_MKNOD was added later, author just forget to
> update mask.
> 
> If mask was designed to drop all filesystem related capabilities, then
> it must be expanded, because ordinary users cannot create devices etc.

I think you thought Bruce was saying we shouldn't change the set of
capabilities, but he was just asking exactly what changes Michael was
interested in.

Igor, thanks for finding this.  I never got your original message.  Do
you have a patdch to add the two capabilities?  Do you think the
other two I mentioned (CAP_SYS_ADMIN and CAP_SETFCAP) need to be
added too?

I've added Andrew Morgan, LSM and SELinux mailing lists to get another
opinion about adding those two.  In particular, we'd be adding them
to the fs_masks becuase CAP_SYS_ADMIN lets you change the selinux
label, and CAP_SETFCAP lets you change the file capabilities.

thanks,
-serge
