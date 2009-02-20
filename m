Return-Path: <linux-kernel-owner+w=401wt.eu-S1758651AbZBTAdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651AbZBTAdi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 19:33:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbZBTAd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 19:33:28 -0500
Received: from web34407.mail.mud.yahoo.com ([66.163.178.156]:49060 "HELO
	web34407.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751170AbZBTAd1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 19:33:27 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.br;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=HgJHh84DkYVMJ+H2T5kQuwNppgHBO72smHmsORbkjIiL2l/BdDYJMYzGL+Bctz1hUsCI7TaWoZpmBsMgfJM/R3FuAeLKW13pnj5RZILvyq/s3Vp6o6DCJokMPuS3ucSRxthBOUtR1IYYu1ByurP3+SAP/oCpqSXjWfuvu+yD9TA=;
X-YMail-OSG: 3OL7V9gVM1njgcFZF1JUPXIOxJivN4Lop9CtG2odsyVZsBAOLuv3HCFTPfVdMSekgyu6iNRhp2MZt_74KL.HmKft_ocYNV27Mxf6fXaiVX9NsRh8pcP_OIuU6ko0dg2qHAYqlLDbdrrV1bKAJKI7esCsf_oBFPXT8_l1ucszSKoD97fqeQ.FpMdfbhEtuT2mKs1pXG4EGnQqeXVyT.4q7qlGdD2Sgg--
X-Mailer: YahooMailWebService/0.7.260.1
Date: Thu, 19 Feb 2009 16:33:25 -0800 (PST)
From: Jose Luis Marchetti <joseluismarchetti@yahoo.com.br>
Reply-To: joseluismarchetti@yahoo.com.br
Subject: Re: Is interrupt priority supported ?
To: Andreas Mohr <andi@lisas.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090219204902.GA3990@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <164929.58875.qm@web34407.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> it has been for a looong time (those things tend to almost
> get outdated already -
> witness the floppy controller misery):

He he, I am from the same era..., I appreciate your answer, but I am afraid your suggestion is not exactly what I was expecting.
The tools you mention appears to act on the hardware level, not on Linux by itself, they apply only to x86 processors ( as you can see by the name ), and I am not running Linux in one of those processors.
Roughly, this is what I have seen in other OSs that support interrupt priority:
Imagine a table with interrupt IDs, in my example they are in decreased priority order:
interrupt priority table:
Serial,
Ethernet,
Keyboard,
etc...
Then, when one interrupt happen, lets say the Ethernet, the OS disable all lower priority interrupts ( keyboard in my example ), but allow the Serial interrupt nest into the Ethernet interrupt.
In my example the serial is the highest priority interrupt and no one could nest into it.

I am not aware of "hardware transceiver offloading of Ethernet frames", thanks for that info and I am going to investigate it.

Thanks!




      Veja quais são os assuntos do momento no Yahoo! +Buscados
http://br.maisbuscados.yahoo.com
