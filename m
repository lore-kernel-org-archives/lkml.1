Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123AbYLOIIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbYLOIIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 03:08:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbYLOIHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 03:07:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:39233 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbYLOIHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 03:07:52 -0500
Date: Mon, 15 Dec 2008 09:09:25 +0100
From: Arjan van de Ven <arjan@infradead.org>
To: "Shi, Alex" <alex.shi@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: is it a timer bug?
Message-ID: <20081215090925.7a8f5c6d@infradead.org>
In-Reply-To: <F7C8A4D3A9905B45A80E4C194793FA6501C51D1271@PDSMSX501.ccr.corp.intel.com>
References: <F7C8A4D3A9905B45A80E4C194793FA6501C51D1271@PDSMSX501.ccr.corp.intel.com>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Dec 2008 15:07:17 +0800
"Shi, Alex" <alex.shi@intel.com> wrote:

> I notice the timer interrupts is quit high on the 2.6.28-rc8 kernel
> in my Nehalem machine. A, 180+/second timer interrupts in my Nehalem
> machine with tickless enable. B, the timer interrupts reduce to
> 10-/second with tickless and highres enable. On 2.6.27 kernel, the
> timer interrupts can keep low with tickless kernel whenever the
> highres feature is enable or not. So it is timer bug on my machine? 
> 

Hi,

can you give us the powertop output of these production Core i7 
machines? That is the most likely way to get a clue about what is going
on...

Greetings,
   Arjan van de Ven

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
