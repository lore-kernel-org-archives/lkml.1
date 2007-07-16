Return-Path: <linux-kernel-owner+w=401wt.eu-S1762695AbXGPO2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762695AbXGPO2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 10:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757675AbXGPO2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 10:28:17 -0400
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:50028 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757064AbXGPO2R convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 10:28:17 -0400
Message-ID: <9335978.1184596094749.JavaMail.ngmail@webmail12>
Date: Mon, 16 Jul 2007 16:28:14 +0200 (CEST)
From: "M. Koehrer" <mathias_koehrer@arcor.de>
To: linux-kernel@vger.kernel.org
Subject: CONFIG_PREEMPT_RT Patch and UDP/IP on Ethernet in real time.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-ngMessageSubType: MessageSubType_MAIL
X-WebmailclientIP: 213.68.15.100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody,

I have a question concerning Ingo Molnar's realtime preempt patch.
This patch is great go get low latency on timer threads and a really
good real time behaviour.
I want to connect an external, embedded device via Ethernet (UDP/IP) 
to my Linux PC. This communication should be in real time as well.
For this I have a separate network adapter in my PC that is used
solely for this UDP Ethernet traffic.
However, I think all Ethernet traffic is be handled by
the soft IRQ threads [softirq-net-rx] [softirq-net-tx] but I do
not see a way to do real time networking via my dedicated network adapter.

How can I get this UDP networking real time capable?

I use kernel 2.6.21.6 and the related realtime preempt patch.
However, this is a general question that is not related to a certain kernel
version.

Any feedback is welcome.

Thanks a lot!

Regards

Mathias




-- 
Mathias Koehrer
mathias_koehrer@arcor.de


Viel oder wenig? Schnell oder langsam? Unbegrenzt surfen + telefonieren
ohne Zeit- und Volumenbegrenzung? DAS TOP ANGEBOT JETZT bei Arcor: günstig
und schnell mit DSL - das All-Inclusive-Paket für clevere Doppel-Sparer,
nur  39,85 €  inkl. DSL- und ISDN-Grundgebühr!
http://www.arcor.de/rd/emf-dsl-2
