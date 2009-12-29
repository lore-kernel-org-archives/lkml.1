Return-Path: <linux-kernel-owner+w=401wt.eu-S1752746AbZL2JGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbZL2JGN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 04:06:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbZL2JGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 04:06:10 -0500
Received: from smtp2b.orange.fr ([80.12.242.146]:2926 "EHLO smtp2b.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714AbZL2JGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 04:06:06 -0500
X-ME-UUID: 20091229090559815.C70048000157@mwinf2b27.orange.fr
Subject: Re: No PCI-X / PCI-E cards ...
From: Xavier Bestel <xavier.bestel@free.fr>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <m363841eye.fsf@intrepid.localdomain>
References: <1260979057.23135.70.camel@skunk> <1261089592.8827.5.camel@bip>
	 <m363841eye.fsf@intrepid.localdomain>
Content-Type: text/plain
Date: Tue, 29 Dec 2009 10:05:45 +0100
Message-Id: <1262077546.7778.1.camel@skunk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-18 at 16:26 +0100, Krzysztof Halasa wrote:
> Xavier Bestel <xavier.bestel@free.fr> writes:
> 
> >> I first plugged a wifi PCI card into a PCI-X slot (there's no PCI slot),
> >> it didn't appear in lspci. As I thought it was a voltage problem (PCI-X
> >> only accept 3.3v, not 5v IIRC)
> 
> The card has to force 33 MHz non-PCI-X mode. I'd check if the "pins" 38B
> (PCIXCAP) and 49B (M66EN) are both connected to GND. Also you can try
> inserting another PCI card into another PCI-X slot (in the same bus
> segment), this may force 33 PCI mode (check if the other card is
> detected).

BTW, when I try 2 PCI cards in both PCI-X slots, the machine doesn't
start (it stays in soft-off state).

	Xav



