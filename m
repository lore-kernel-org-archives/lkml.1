Return-Path: <linux-kernel-owner+w=401wt.eu-S1759530AbZCXMW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759530AbZCXMW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 08:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179AbZCXMWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 08:22:15 -0400
Received: from mail-ausfall.charite.de ([193.175.70.131]:46762 "EHLO
	mail-ausfall.charite.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050AbZCXMWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 08:22:14 -0400
Date: Tue, 24 Mar 2009 13:22:11 +0100
From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
To: linux-kernel@vger.kernel.org
Subject: Re: tg3 driver fails to load firmware (2.6.29)
Message-ID: <20090324122211.GS12613@charite.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20090324120948.GO12613@charite.de> <20090324121608.19f71ce2@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090324121608.19f71ce2@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alan Cox <alan@lxorguk.ukuu.org.uk>:
> On Tue, 24 Mar 2009 13:09:48 +0100
> Ralf Hildebrandt <Ralf.Hildebrandt@charite.de> wrote:
> 
> > >From the log:
> > 
> > Mar 24 09:02:42 proxy-cvk-2 kernel: [   39.078323] tg3 0000:02:02.0: PME# disabled
> > Mar 24 09:02:42 proxy-cvk-2 kernel: [   40.600196] tg3 0000:02:02.1: firmware: requesting tigon/tg3_tso.bin
> > Mar 24 09:02:42 proxy-cvk-2 kernel: [   41.723404] tg3: eth0: Link is up at 1000 Mbps, full duplex.
> > Mar 24 09:02:42 proxy-cvk-2 kernel: [   41.723458] tg3: eth0: Flow control is on for TX and on for RX.
> > Mar 24 09:02:42 proxy-cvk-2 kernel: [  100.599130] eth1: Failed to load firmware "tigon/tg3_tso.bin"
> > Mar 24 09:02:42 proxy-cvk-2 kernel: [  100.599184] eth1: TSO capability disabled.
> > Mar 24 09:02:42 proxy-cvk-2 kernel: [  100.599241] tg3 0000:02:02.1: PME# disabled
> > 
> > but:
> > 
> > # ll /lib/firmware/2.6.29/tigon/tg3_tso.bin
> > -rw-r--r-- 1 root root 7004 Mar 24 09:24 /lib/firmware/2.6.29/tigon/tg3_tso.bin
> 
> Is your userspace configured to use /lib/firmware/2.6.29 or the more
> usual /lib/firmware/ ?

Which leads to the next question: How to I find out?

-- 
Ralf Hildebrandt
  Geschäftsbereich IT | Abteilung Netzwerk
  Charité - Universitätsmedizin Berlin
  Campus Benjamin Franklin
  Hindenburgdamm 30 | D-12200 Berlin
  Tel. +49 30 450 570 155 | Fax: +49 30 450 570 962
  Ralf.Hildebrandt@charite.de | http://www.charite.de
