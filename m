Return-Path: <linux-kernel-owner+w=401wt.eu-S1756287AbYE0AW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287AbYE0AW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 20:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753616AbYE0AWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 20:22:21 -0400
Received: from namei.org ([69.55.235.186]:52674 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752460AbYE0AWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 20:22:21 -0400
Date: Tue, 27 May 2008 10:20:17 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Markku Savela <msa@moth.iki.fi>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: Bug/misfeature of "securityfs"
In-Reply-To: <87iqx1pd24.fsf@burp.tkv.asdf.org>
Message-ID: <Xine.LNX.4.64.0805271019550.17391@us.intercode.com.au>
References: <87iqx1pd24.fsf@burp.tkv.asdf.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 May 2008, Markku Savela wrote:

> 
> I write a module which creates a securityfs on init
> 
>   foobar =  securityfs_create_dir("foobar", NULL)
> and on exit it does
>   security_fs_remove(foobar);
> 
> When I do "insmod" and "rmmod", I see
> 
>   /sys/kernel/security/foobar/
> 
> appear and go away.
> 
> Now, if have a shell and do "cd /sys/kernel/security/foobar", the
> "rmmod" does not remove the directory. The directory disappears when I
> exit the shell from it via "cd ..". This is fine, and as it should be,
> but....
> 
> IF, while having the shell in the directory, I try to "insmod" again,
> the insmod fails with "-1 File exists". Again, understandable, BUT
> when after this I exit the shell from the directory, IT DOES NOT GO
> AWAY. It's permanetly existing, and module install fails always with
> "File Exists".
> 
> Is this a bug, or am doing something wrong?
> 
> The kernel is Ubuntu Hardy heron
>     2.6.24-16-generic #1 SMP Thu Apr 10 13:23:42 UTC 2008 i686

Sounds like a bug.


-- 
James Morris
<jmorris@namei.org>
