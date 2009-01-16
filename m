Return-Path: <linux-kernel-owner+w=401wt.eu-S1765520AbZAPJ2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765520AbZAPJ2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 04:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761462AbZAPJ2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 04:28:10 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:25879 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761132AbZAPJ2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 04:28:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vHXfoSb7O22HVHXwgkAJI2aBfIgh1+DH0j28b8TVaN6cB65dqSITV3Lwtw3yQ0fttf
         jMP1msxKUMh41s/3Lz41lTIx+/2KbyPinRNzqs2bjSUZLEQI70o6v7gl3+fA/BtTp0sz
         zqo9m2wr4bRjwAVukkT5gu2nFAGFc79P3Ye14=
Message-ID: <49705322.8010309@gmail.com>
Date: Fri, 16 Jan 2009 01:28:02 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Amon Ott <ao@rsbac.org>
CC: linux-kernel@vger.kernel.org, SE-Linux <selinux@tycho.nsa.gov>
Subject: Re: Announce: RSBAC 1.4.0 released
References: <200901160948.32172.ao@rsbac.org>
In-Reply-To: <200901160948.32172.ao@rsbac.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amon Ott wrote:
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
>   *  VUM (Virtual User Management) support (http://rsbac.org/redir.php?t=vum)
>   * One time password support for user management 
> (http://rsbac.org/redir.php?t=otp)
>   * Code for kernels 2.4 and 2.6 has been separated. 2.4 kernels might
> be phased out at a later date.
>   * PAM module does not send a message "User not authenticated" anymore
> if authentication failed. (To match other PAM modules behavior)
>   * Made PAM password prompt standard and definable to RSBAC's custom
> prompt if the user wants it only.
>   * rsbac_useradd -K to copy a user with password.
>   * rsbac_mount now uses kernel's vfs_mount
>
>
> About RSBAC 1.4:
> ---
>
> RSBAC 1.4 mainly introduces the new Virtual User Management feature ( 
> (http://rsbac.org/redir.php?t=vum),
> which allows to isolate complete sets of users in so-called "virtual sets". 
> Every user in every set can have individual passwords and access rights.
>
> As an example, you can start your mail server in a different set, and
> the users getting the email will not be part of the system users.
>
> Likewise, your jails can be started in a different set, so that the
> users in that jail will never be the same ones as the real system users.
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
>   
alright a new security mechanism!!
(still need to learn UBAC though);
Anyways I'll have to give this a shot.

regards;

Justin P. Mattoxk
