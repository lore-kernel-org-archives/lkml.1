Return-Path: <linux-kernel-owner+w=401wt.eu-S1030179AbXBFWTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030179AbXBFWTr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 17:19:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030183AbXBFWTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 17:19:47 -0500
Received: from web26914.mail.ukl.yahoo.com ([217.146.177.81]:23784 "HELO
	web26914.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030179AbXBFWTq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 17:19:46 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=0PLgAwRvPw4cWYlWqIKdXFf2twOlVaRLmMSyyP+N4auVzxFjJU834x4TA6T9nC8E5yuHFDKae1Mj+FwqQtsxANeRWmaiNt9+sAX7WCBtEVel4W90f9Vz6xBIckYLaOxl9RdTRom42j5O3+8j4TtBHOtybunMKj3LjqqW4i8XZvg=;
X-YMail-OSG: E3BkJp4VM1ksTcQVbATbpwNF2p92KD1lW5oUPBY7iNnOqD2mdvwGUQXTmkWnIndnaUYl7M0DWnqjYGWXnykG1RJPLPFXHwSy7wdwhgMy_7Zm6DRHWUdx.7UGv8wAbDT03FFketZ2
X-Mailer: YahooMailRC/368.3 YahooMailWebService/0.6.132.7
Date: Tue, 6 Feb 2007 22:19:44 +0000 (GMT)
From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: Re : Re : Re : Re : [PATCH] Compressed ia32 ELF file generation for loading by Gujin 1/3
To: "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Cc: vgoyal@in.ibm.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <965140.82745.qm@web26914.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> I've long wished that someone would do a proper 16-bit x86 port of gcc; 

> however, the .code16gcc is usually good enough, although it produces 
> code which is a lot bigger than it needs to be.

  It is only that much bigger if you compare to 16 bits integer compilers,

 but once you deal with 32 bits integers in real mode you have one extra byte

 out of the two - which is still better than dealing with dx:ax.

 Last time I compiled (long time ago) some piece of code with and without

 .code16gcc it was approx 15% bigger - approx what you get when optimising.


 Etienne.




	

	
		
___________________________________________________________________________ 
Découvrez une nouvelle façon d'obtenir des réponses à toutes vos questions ! 
Profitez des connaissances, des opinions et des expériences des internautes sur Yahoo! Questions/Réponses 
http://fr.answers.yahoo.com
