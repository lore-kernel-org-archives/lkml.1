Return-Path: <linux-kernel-owner+w=401wt.eu-S1763645AbYESVqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763645AbYESVqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 17:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755440AbYESVqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 17:46:31 -0400
Received: from smtp.innovsys.com ([66.115.232.196]:29238 "EHLO
	mail.innovsys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751873AbYESVqa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 17:46:30 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Oops with PREEMPT-RT on 2.6.25.4
Date: Mon, 19 May 2008 16:46:51 -0500
Message-ID: <DCEAAC0833DD314AB0B58112AD99B93B04690276@ismail.innsys.innovsys.com>
In-Reply-To: <4831F364.8020702@freescale.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Oops with PREEMPT-RT on 2.6.25.4
Thread-Index: Aci5+J6ojbKZxg0nSOirDnCOGqoJnAAAK2Wg
References: <DCEAAC0833DD314AB0B58112AD99B93B0469010C@ismail.innsys.innovsys.com>	<4831D527.2020907@freescale.com> <DCEAAC0833DD314AB0B58112AD99B93B04690162@ismail.innsys.innovsys.com> <4831ECF0.5090101@freescale.com> <DCEAAC0833DD314AB0B58112AD99B93B04690239@ismail.innsys.innovsys.com> <4831F364.8020702@freescale.com>
From: "Rune Torgersen" <runet@innovsys.com>
To: "Scott Wood" <scottwood@freescale.com>
Cc: <linuxppc-dev@ozlabs.org>, <linux-kernel@vger.kernel.org>,
       <linux-ide@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scott Wood wrote:
> Try calling irq_set_chip_and_handler() with handle_level_irq, rather
> than irq_set_chip().  The -rt patch doesn't seem to have threadified
>   the __do_IRQ() path.

The demuxer is setting itself up with set_irq_chained handler(), any
pointers on how to change to irq_set_chip_and_handler()?
