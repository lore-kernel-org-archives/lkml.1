Return-Path: <linux-kernel-owner+w=401wt.eu-S965041AbXBFSjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965041AbXBFSjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 13:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964784AbXBFSjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 13:39:18 -0500
Received: from web26913.mail.ukl.yahoo.com ([217.146.177.80]:24264 "HELO
	web26913.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965244AbXBFSjQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 13:39:16 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=BHWTJ26klQh3ED80GkugnE1I0XWmloUmGOKWR7BXQ9Ivteyc0z/sU/h2tiyuksETu/KE4Ru6foFEo2cUrhoJDmtRmW/mKCR62pDG7VC6NtDc3JAEcsWpGIFP53eLtv3NSLQBNTVGgpei8/VD1ev8t6rbS0sQjpvzbgG5w6iiWEI=;
X-YMail-OSG: HEr5QXgVM1miqSf8skX9DwHA5Q7MiRFIHIz7hwB4NSPZjew3HPLJpl.VlfIq_5M90RbRQqRhwGLLUl3fHCehqNhy1EevamAeSMj7rl44sBGDTPNvFcG2Fglam1Ebny6zGerQOwWo3LrrsALZw0nctdCGOWQcEmIVO4JOmfkbyKAxYI640NGt80kuVg--
X-Mailer: YahooMailRC/368.3 YahooMailWebService/0.6.132.7
Date: Tue, 6 Feb 2007 18:39:11 +0000 (GMT)
From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: Re : Re : [PATCH] Compressed ia32 ELF file generation for loading by Gujin 1/3
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, vgoyal@in.ibm.com,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <988792.74810.qm@web26913.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Etienne Lorrain <etienne_lorrain@yahoo.fr> writes:
> >  New features are more that this real-mode function can return an error
> >  to the bootloader to tell something to the user, so the user can select
> >  another kernel with the right processor, another video mode... with
> >  clean error messages - not a crash dump because this assembly
> >  instruction is not for that processor.
>
> Having an error handling compatibility that is backwards compatible sounds
> interesting.

 Well, if the function called at offset 0 in the real-mode section return
 non zero, that is probably an error - that is Gujin interface, but do not ask
 me to change other bootloaders to handle that.
 This function is called with few parameters, one is a string pointer
 if the function do not want to print the problem report itself.
 The function is called with an offset of zero in its own intel segment.

> >   I am still saying that the bootloader knows the root filesystem to
> >  be used by the kernel it loads, and that ELF is a clean format to
> >  store different sections to be loaded into memory at predefined
> >  addresses.
> 
> Yes.  Although when you think sections instead of segments I'm a little
> worried.

  Well, for my defense, if Gujin do not find the real mode code in the program
 header it search for it in the section table, if the program header cannot be
 modified for some reason. There may be some issues if that ELF file is
 "stripped" but it seems to work on my side.

> >  Also there isn't any more kernel size limit.
>
> I think as HPA points out we have gotten past that a long time
> ago with the bzImage format.

  There was still a test not that long ago (in the code I am not executing) - but
 I was wrong to bring this point forward.

> With the right delicacy, and preserving backwards compatibility
> with existing bootloaders I think we can achieve things.

  Well, you can generate with the proposed patch and boot with SYSLINUX,
 Grub and LILO, but trying to clean Linux real-mode code is where I begun.

> The big issue is that sometimes bootloaders are a little bit brittle.
> Eric

  I like to think mine is more stable - maybe I am a dreamer...
  I do not compete on network booting neither.

  Etienne.


	

	
		
___________________________________________________________________________ 
Découvrez une nouvelle façon d'obtenir des réponses à toutes vos questions ! 
Profitez des connaissances, des opinions et des expériences des internautes sur Yahoo! Questions/Réponses 
http://fr.answers.yahoo.com
