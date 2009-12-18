Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbZLRP0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbZLRP0M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 10:26:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754534AbZLRP0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 10:26:07 -0500
Received: from khc.piap.pl ([195.187.100.11]:39692 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427AbZLRP0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 10:26:03 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Xavier Bestel <xavier.bestel@free.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: No PCI-X / PCI-E cards ...
References: <1260979057.23135.70.camel@skunk> <1261089592.8827.5.camel@bip>
Date: Fri, 18 Dec 2009 16:26:01 +0100
In-Reply-To: <1261089592.8827.5.camel@bip> (Xavier Bestel's message of "Thu,
	17 Dec 2009 23:39:52 +0100")
Message-ID: <m363841eye.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xavier Bestel <xavier.bestel@free.fr> writes:

>> I first plugged a wifi PCI card into a PCI-X slot (there's no PCI slot),
>> it didn't appear in lspci. As I thought it was a voltage problem (PCI-X
>> only accept 3.3v, not 5v IIRC)

The card has to force 33 MHz non-PCI-X mode. I'd check if the "pins" 38B
(PCIXCAP) and 49B (M66EN) are both connected to GND. Also you can try
inserting another PCI card into another PCI-X slot (in the same bus
segment), this may force 33 PCI mode (check if the other card is
detected).
-- 
Krzysztof Halasa
