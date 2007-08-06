Return-Path: <linux-kernel-owner+w=401wt.eu-S1760995AbXHFImw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760995AbXHFImw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 04:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756783AbXHFImm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 04:42:42 -0400
Received: from web26902.mail.ukl.yahoo.com ([217.146.176.91]:23911 "HELO
	web26902.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755993AbXHFImi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 04:42:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=0a0z2BVl+IJEhrtU9d9eChdg6ApnTY/FXC9qfU3vu/RTVmka9iWHfQHLEpHIuz/ABbHeJ2EwCf4ysN4w0yulqGc6TA0eDMjM8PsyGp8SKpaZW00zBAWzxtj+jY/3H2AiqxZv7fu2r9a0BvUf5FBoZU2nCK/bMRaaV+43Q1SgnAE=;
X-YMail-OSG: U_6.4QYVM1krAQqJRj17yY32rlCNFnf1bf59nMjkArKM0tibNHNqEorylf2fKjs.HaqIxgwVzw--
Date: Mon, 6 Aug 2007 10:42:36 +0200 (CEST)
From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: RE : Re: Complete freeze if high traffic on standard serial line on ia32?
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070803141347.19136546@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <723242.80125.qm@web26902.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >  I can reliably (6 times in one hour) freeze completely (Scroll lock/Caps lock
> > flashing together, mouse frozen in X) my PC (AMD sempron on MSI K8MM3-V K8M800
> > Socket 754) by doing an FTP using a standard modem connected on the serial port
> > of the motherboard, and a bit of browsing (i.e. machine not loaded).
> >  That happens on standard Fedora 7 kernel and on the latest 23-rc1 kernel, and
> > doesn't happen on a Puppy Linux 2.17 bootable CDROM.
> 
> Can you get this to happen outside of X at all (eg if you do a yum update
> and pull in packages over the modem for a while with 2.6.23-rc1  does it
> die). Just trying to work out what has become unstable.
> 
> Also worth trying to see if browsing web type stuff off a CD or local
> files triggers it without the network link.

 Did a few more tests:
 - Cannot reproduce without X running and on display (i.e. Crtl-Alt-F1 and FTP works)
 - Tried another video board (Matrox AGP) and everything works.
 - With the motherboard integrated video (identified by its VESA BIOS name as
 VIA K8M800), it can fail even without doing an FTP - but you need to browse - i.e.
 serial modem connection needs to be active. This video card claims to use shared
 video memory.
 - I tried to find few logs files of X (I do not know much in this area) but since
 I have added the Matrox AGP board, and removed it, X refuses to start. I did not
 have time to inverstigate why.

 Etienne.


      _____________________________________________________________________________ 
Ne gardez plus qu'une seule adresse mail ! Copiez vos mails vers Yahoo! Mail 
