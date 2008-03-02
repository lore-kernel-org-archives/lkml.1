Return-Path: <linux-kernel-owner+w=401wt.eu-S1755715AbYCBQAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715AbYCBQAT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 11:00:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753711AbYCBQAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 11:00:05 -0500
Received: from n3.bullet.mail.ac4.yahoo.com ([76.13.13.29]:28906 "HELO
	n3.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753526AbYCBQAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 11:00:03 -0500
X-Greylist: delayed 388 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Mar 2008 11:00:03 EST
X-Yahoo-Newman-Id: 682526.21704.bm@omp106.mail.re1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:OpenPGP:Content-Type:Content-Transfer-Encoding;
  b=5ZSR+tT/5s2bvAanL4a3JbI906WvbLTeJo54Xlk7xGaVAMoxjU8WR9teJo3A4Wxei6IFLGIRivOL3HVVJVp4Tkrmzf+o1GZtK1ZB4Si4AuQsoR7oVP+ojSRtXC65hUmQZsMl/hmNNUt7whEHn7tElbdiNXQeaUGD/x+r6qNgmTU=  ;
X-YMail-OSG: GmwSxbIVM1mSpljPMk2wxwnrLwhENPg98uKHlZvE9NZypSd3RuNdFJHbHSkwu6Yp2D3k5yD0XMeyNrAy.uHBnIzQodgBrkInK6Rj.vq7GrNaDr07zArMAPZZbNYK6Q--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <47CACD7A.9000809@yahoo.it>
Date: Sun, 02 Mar 2008 16:53:30 +0100
From: Filippo Zangheri <filippo.zangheri@yahoo.it>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Pawel Plociennik <paplociennik@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] chroot= as a new kernel parameter
References: <200803011409.59526.paplociennik@gmail.com>
In-Reply-To: <200803011409.59526.paplociennik@gmail.com>
X-Enigmail-Version: 0.95.6
OpenPGP: id=E1D879FA;
	url=http://pgp.mit.edu:11371/pks/lookup?op=get&search=0xE1D879FA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pawel Plociennik ha scritto:
> hi *real* hackers,
(...)

> diff -urp linux-2.6.24-orig/Documentation/kernel-parameters.txt linux-2.6.24/Documentation/kernel-parameters.txt
> --- linux-2.6.24-orig/Documentation/kernel-parameters.txt	2008-02-25 20:53:26.000000000 -0500
> +++ linux-2.6.24/Documentation/kernel-parameters.txt	2008-02-25 20:51:21.000000000 -0500
> @@ -381,6 +381,8 @@ and is between 256 and 4096 characters. 
>  			Value can be changed at runtime via
>  				/selinux/checkreqprot.
>  	
> +	chroot=		[KNL] call chroot() for init proccess.

Isn't the called function 'sys_chroot()'?


(...)
> +		if(sys_chroot(chroot_str) < 0)
> +			printk("chroot=%s failed\n", chroot_str);

Thanks.


-- 
Filippo Zangheri

GPG key ID: 0xE1D879FA
Key fingerprint: 816B CE57 D43C 0A47 EF35 3378 EA5F A72A E1D8 79FA
Key server: pgp.mit.edu

-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GE d- s+:- a-- C++ UL+++ P+ L+++ E-- W+ N* o-- K- w--- O-- M--  
V- PS++ PE+ Y+ PGP++ t 5-- X++ R* tv b+ DI-- D---- G-- e++ h--  
r++ z*                                                          
------END GEEK CODE BLOCK------

