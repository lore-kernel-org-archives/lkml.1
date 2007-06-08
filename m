Return-Path: <linux-kernel-owner+w=401wt.eu-S969521AbXFHP1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969521AbXFHP1a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 11:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762996AbXFHP1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 11:27:23 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:17614 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760162AbXFHP1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 11:27:22 -0400
Date: Fri, 8 Jun 2007 17:27:21 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Include <asm/termbits.h> from <linux/tty_driver.h>.
In-Reply-To: <20070608163018.636b74d1@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64.0706081727110.10769@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0706080925020.24228@localhost.localdomain>
 <20070608163018.636b74d1@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 8 2007 16:30, Alan Cox wrote:
>
>> 
>> The header file <linux/tty_driver.h> should include <asm/termbits.h>
>> to pick up the definition of "struct ktermios"; otherwise, you run the
>> risk of seeing:
>
>Risk - which compile combinations does it actually show up with and is it
>not better to fix the C file in question not grow the horribly tangled
>include deps further

struct ktermios; /* that's it */


	Jan
-- 
