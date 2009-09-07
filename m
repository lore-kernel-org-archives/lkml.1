Return-Path: <linux-kernel-owner+w=401wt.eu-S1758632AbZIGBdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632AbZIGBdh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 21:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758589AbZIGBdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 21:33:37 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:34788 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758409AbZIGBdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 21:33:36 -0400
X-Sasl-enc: eDPKwUOJ8fDt/lwhpdfBBUzmTwJmGqOJWI0e/Jl09h1g 1252287217
Date: Sun, 6 Sep 2009 22:33:28 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Stefan Assmann <sassmann@redhat.com>
Cc: linux-kernel@vger.kernel.org, jcm@redhat.com, sdietrich@novell.com,
       linux-acpi@vger.kernel.org, andi@firstfloor.org, hpa@zytor.com,
       mingo@elte.hu, Olaf.Dabrunz@gmx.net, ktokunag@redhat.com,
       tglx@linutronix.de, lenb@kernel.org
Subject: Re: [RFC][PATCH 0/2] boot interrupts on Intel X58 and 55x0
Message-ID: <20090907013328.GA19670@khazad-dum.debian.net>
References: <20090904165525.26294.31112.sendpatchset@t500>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090904165525.26294.31112.sendpatchset@t500>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Sep 2009, Stefan Assmann wrote:
> is more serious namely the onboard NIC (8086:10c9) is malfunctioning on some
> of our test system if the second patch is applied. It fails to acquire an IP
> from DHCP and we're pretty clueless on this issue right now.
> Help is greatly appreciated!

Did you read Intel documet 320839-009, August/2009, already?  It is at:
http://www.intel.com/Assets/PDF/specupdate/320839.pdf

I see some stuff there that might be a problem, many of the "issues" are
related to interrupt handling.  Errata 40 (EOI to IOAPIC can be blocked)
even states that one should avoid the X58 IOH IOAPIC on stepping B2
completely, and use the IOAPIC in the ICH10R instead.

And the B2 stepping is the one in most motherboards (B3 is quite new).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
