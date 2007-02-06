Return-Path: <linux-kernel-owner+w=401wt.eu-S1752103AbXBFNXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbXBFNXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 08:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbXBFNXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 08:23:21 -0500
Received: from web26902.mail.ukl.yahoo.com ([217.146.176.91]:32583 "HELO
	web26902.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752103AbXBFNXU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 08:23:20 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=AhfrUaEzT+bbPBxL1iQZKQ4NkkQW/YumvnQvNzj+yJ6nU+5pG3ypkjahpC4u+49+lm2Dy28cfoEfG6VoKjUKT9efLedQA6SJvX3cCK+j4MtfYpo678gF1q0vlnyRB/mcLBZk2cRaCsxc7JqCmfW16ZpzXNPI9pvlhd8Eeoeovvo=  ;
Message-ID: <20070206132319.37718.qmail@web26902.mail.ukl.yahoo.com>
X-YMail-OSG: krqB7_AVM1lDjLU9Obmi5a32XdUpYP0zfgRrnhED2HEWAY7x8e7Wvl8kZ717STyfhs9Pw1oT.JWkeUFZUVROTyM8WgVYo4jF0d1VK7SeW63R4jMAC0sCSCTreEYFahj_5Yv_cMf5
X-Mailer: YahooMailRC/368.3 YahooMailWebService/0.6.132.7
Date: Tue, 6 Feb 2007 13:23:19 +0000 (GMT)
From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: Re : [PATCH] Compressed ia32 ELF file generation for loading by Gujin 1/3
To: "Eric W. Biederman" <ebiederm@xmission.com>, vgoyal@in.ibm.com
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin, Vivek Goyal wrote:
>> Either way, though, putting Gujin-specific code in the main kernel 
>> output is a pretty dull thud.
>
> Agreed.

 May I ask if you are refering to the Gujin structures under the
ROOT_EXTENSIVE_SEARCH compilation switch, or the
C structures describing the BIOS which could even be used
in the kernel?

Eric W. Biederman wrote:
> From what little I skimmed part of what Gujin wanted to do was sane
> at first glance. Just boot a gziped vmlinux like the other
> architectures.  The problem was the 16bit code.

 So without ROOT_EXTENSIVE_SEARCH defined.
 It is so usefull when you have loads of distributions...
 But yes, maybe that part should be in another file, maybe
 not a complete directory for a single file.
 There is also a special problem with ia32, the number of processor
 involved and their partial compatibilities, that Gujin try to help with.

> So there may be some good ideas buried in there somewhere, but it
> likely to take some doing, and patches that I have to save before
> I read them are a real pain!

 Last time I used this web interface it did not encode text files...

> Eric

 Thanks,
  Etienne.


	

	
		
___________________________________________________________________________ 
Découvrez une nouvelle façon d'obtenir des réponses à toutes vos questions ! 
Profitez des connaissances, des opinions et des expériences des internautes sur Yahoo! Questions/Réponses 
http://fr.answers.yahoo.com
