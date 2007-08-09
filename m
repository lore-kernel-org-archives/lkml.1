Return-Path: <linux-kernel-owner+w=401wt.eu-S937026AbXHILYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937026AbXHILYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 07:24:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762136AbXHILX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 07:23:59 -0400
Received: from web26910.mail.ukl.yahoo.com ([217.146.176.99]:20199 "HELO
	web26910.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756682AbXHILX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 07:23:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=hjJ42zAHLZ6oqBtiqmCfyKvKnZd6rKGmFW2ugEof0OAzas+Q6PtgFqVptKGSOoEzzxK2+LB8ujZCfN1DFD0iDLTgWcIUfLLq6Lv4Hb1ig6KFo58InGHZuLINco8r6gGjF4208dPlzycQ9+1lGB86Z8L64TFQXI1FSzFTkKCc1gY=;
X-YMail-OSG: 8FbRkYMVM1mNLAVF70W67A7DBxf13AWDwPeTs1wfrrIx_TDc8SoXJytrbn0WrHEZAUDXjw--
Date: Thu, 9 Aug 2007 13:23:56 +0200 (CEST)
From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: RE : Re: [PATCH 5/5] x86_64 EFI support -v3: EFI document
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com
In-Reply-To: <200708091251.21726.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <741983.8529.qm@web26910.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Andi Kleen <ak@suse.de> wrote:
> >  Note that Gujin has a simple problem by using that 32 bits entry point:
> 
> There is really no 32bit entry point today usable for external users.

 That is why I added the 16 bits entry point support (selected by default),
my target with Gujin was not only to load Linux but also another simpler
format - gzip'ed ELF 32/64 files with real-mode embedded at address 0 .
 I also had to show that it was possible to write the Linux-real-mode
code in C with GCC so that someone else would do it and maintain it.
 I may (in few version) remove Gujin code which fills Linux zero-page
structure if the 16 bit entry point works in all cases (mostly in DOS
which help me to create a DBG debug file to sort out Gujin/BIOS problems
remotely).
 I may maintain another patch to produce this gzip'ed ELF32/64 for Linux
as an example of how to use that Gujin interface, but that is not really
related. That patch is in Gujin Sourceforge download.
 Note that I call (instead of jump to) the 16 bits entry point so that
this "function" can return to the bootloader if it detects a problem.

 Etienne.


      _____________________________________________________________________________ 
Ne gardez plus qu'une seule adresse mail ! Copiez vos mails vers Yahoo! Mail 
