Return-Path: <linux-kernel-owner+w=401wt.eu-S1752272AbXBFRYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272AbXBFRYB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 12:24:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932622AbXBFRYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 12:24:01 -0500
Received: from web26903.mail.ukl.yahoo.com ([217.146.176.92]:39363 "HELO
	web26903.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752272AbXBFRYA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 12:24:00 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=fzaPxK8bbKFe48uBOwjeeO4Ka/Rv8Kln+ovrvMNRy5NeqotXY9fiJlc0BGGRTziUx58xswVKkGu+cwWH4RpUlO/ykPyO15kloK81IJ/Sx2/uHeyPio9xa8Y6uUBSugTSDwPFjrH4O14pf+rDiS33OE3NWXRulqpuc3h8P6zxlhk=;
X-YMail-OSG: HnuTRxsVM1mDRwp4Q8wlrEi8DtynePDTsIiyVbfjx6mspJYcevVgefP8m2A8ThGADuiY_akAT1Qcn.h2OhCx1HdQPWUPM8I6hH7VV5mjcnBvsPoqqYGrENBg28bHEuo5eXKBSYnbzniY
X-Mailer: YahooMailRC/368.3 YahooMailWebService/0.6.132.7
Date: Tue, 6 Feb 2007 17:23:55 +0000 (GMT)
From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: Re : [PATCH] Compressed ia32 ELF file generation for loading by Gujin 1/3
To: "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Cc: vgoyal@in.ibm.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <957176.28334.qm@web26903.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Actually, as far as I can see, he has re-invented having a real-mode 
> code chunk which then gets run before the protected-mode kernel.  We 
> already have that!

  I did not claim to have invented anything there, this is just a quite
 simple C code to execute instead of the current real mode assembly:
 it is a rewrite with obvious advantages/disadvantages.
 New features are more that this real-mode function can return an error
 to the bootloader to tell something to the user, so the user can select
 another kernel with the right processor, another video mode... with
 clean error messages - not a crash dump because this assembly
 instruction is not for that processor.
  I am still saying that the bootloader knows the root filesystem to
 be used by the kernel it loads, and that ELF is a clean format to
 store different sections to be loaded into memory at predefined
 addresses. Also there isn't any more kernel size limit.

 Etienne.


	

	
		
___________________________________________________________________________ 
Découvrez une nouvelle façon d'obtenir des réponses à toutes vos questions ! 
Profitez des connaissances, des opinions et des expériences des internautes sur Yahoo! Questions/Réponses 
http://fr.answers.yahoo.com
