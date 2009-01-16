Return-Path: <linux-kernel-owner+w=401wt.eu-S1765538AbZAPKQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765538AbZAPKQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 05:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758899AbZAPKQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 05:16:05 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:8307 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758165AbZAPKQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 05:16:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:x-mailer:mime-version:subject:date:cc;
        b=k41G18PDTAelaPLgeUCKwecSrb2k2wU/i2ZLLAdpaSK/O08qAffeujKRE27p9ciFmJ
         A7BBGyPYUZusD9bAGHqj0rsU0bS7rviEnOT6Kgx+JIhOfmEVTDSLaW2vsoyZahFHnH3i
         OT35SpRyuAWv9yi0mnWcQfsZVirKz+XnEBd6Y=
References: <200901160948.32172.ao@rsbac.org>
Message-Id: <069484CC-549F-4B2E-A4B7-A92415E0F124@gmail.com>
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: Amon Ott <ao@rsbac.org>
In-Reply-To: <200901160948.32172.ao@rsbac.org>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (5G77)
Mime-Version: 1.0 (iPhone Mail 5G77)
Subject: Re: Announce: RSBAC 1.4.0 released
Date: Fri, 16 Jan 2009 02:15:50 -0800
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ahh.. I couldn't help it
(really excited for a new feature
In security); jumped the gun with
Adding cc's(I'll try not to do that);

Regards;

justin P. Mattock



On Jan 16, 2009, at 12:48 AM, Amon Ott <ao@rsbac.org> wrote:

> Rule Set Based Access Control (RSBAC) 1.4.0 has been released for both
> Linux kernels 2.4.37 and 2.6.27.10
> You can download the new version from http://www.rsbac.org
>
> RSBAC is one of the leading access control systems for the Linux
> kernel with a good selection of access control models, see
> http://www.rsbac.org/why for more details.
>
> Important changes since 1.3 series:
>
>  *  VUM (Virtual User Management) support (http://rsbac.org/redir.php?t=vum 
> )
>  * One time password support for user management
> (http://rsbac.org/redir.php?t=otp)
>  * Code for kernels 2.4 and 2.6 has been separated. 2.4 kernels might
> be phased out at a later date.
>  * PAM module does not send a message "User not authenticated" anymore
> if authentication failed. (To match other PAM modules behavior)
>  * Made PAM password prompt standard and definable to RSBAC's custom
> prompt if the user wants it only.
>  * rsbac_useradd -K to copy a user with password.
>  * rsbac_mount now uses kernel's vfs_mount
>
>
> About RSBAC 1.4:
> ---
>
> RSBAC 1.4 mainly introduces the new Virtual User Management feature (
> (http://rsbac.org/redir.php?t=vum),
> which allows to isolate complete sets of users in so-called "virtual  
> sets".
> Every user in every set can have individual passwords and access  
> rights.
>
> As an example, you can start your mail server in a different set, and
> the users getting the email will not be part of the system users.
>
> Likewise, your jails can be started in a different set, so that the
> users in that jail will never be the same ones as the real system  
> users.
>
> You can specify the user set with the usual tools by specifying the
> full user path, e.g.:
>
> 0/0 defines user id 0 (root) in virtual set 0 (eg system user root)
> 0/1000 defines user id 1000 in virtual set 0 (eg a system user)
> 1/secoff defines user secoff in virtual set 1 (e.g. with uid 400)
> 2/1000 defines user id 1000 in virtual set 2 (for example, mail users
> could be in set 2)
>
> Amon.
> -- 
> http://www.rsbac.org - GnuPG: 2048g/5DEAAA30 2002-10-22
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
