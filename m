Return-Path: <linux-kernel-owner+w=401wt.eu-S1754435AbYLOI3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbYLOI3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 03:29:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbYLOI3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 03:29:43 -0500
Received: from casper.infradead.org ([85.118.1.10]:43501 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbYLOI3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 03:29:42 -0500
Date: Mon, 15 Dec 2008 09:31:15 +0100
From: Arjan van de Ven <arjan@infradead.org>
To: "Shi, Alex" <alex.shi@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: is it a timer bug?
Message-ID: <20081215093115.44b4aa0c@infradead.org>
In-Reply-To: <F7C8A4D3A9905B45A80E4C194793FA6501C51D1352@PDSMSX501.ccr.corp.intel.com>
References: <F7C8A4D3A9905B45A80E4C194793FA6501C51D1271@PDSMSX501.ccr.corp.intel.com>
	<20081215090925.7a8f5c6d@infradead.org>
	<F7C8A4D3A9905B45A80E4C194793FA6501C51D1352@PDSMSX501.ccr.corp.intel.com>
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

On Mon, 15 Dec 2008 16:19:37 +0800
"Shi, Alex" <alex.shi@intel.com> wrote:

> OK, but my machine is not a production machine. 
> A, 2.6.28-rc8 with tickles and highres
>      PowerTOP version 1.9       (C) 2007 Intel Corporation
> 
> Cn                Avg residency       P-states (frequencies)
> C0 (cpu running)        (65.1%)
> C1                0.0ms ( 0.0%)
> C2              105.8ms (34.9%)
> 
> 
> 
> Wakeups-from-idle per second :  3.8     interval: 5.0s
> no ACPI power usage estimate available
> B, 2.6.28-rc8 with tickless only 
>      PowerTOP version 1.9       (C) 2007 Intel Corporation
> 
> Cn                Avg residency       P-states (frequencies)
> C0 (cpu running)        (14.0%)
> C1                0.0ms ( 0.0%)
> C2                3.4ms (86.0%)
> 
> 
> 
> Wakeups-from-idle per second : 255.6    interval: 5.0s
> no ACPI power usage estimate available
> 
> Top causes for wakeups:
>   87.9% (267.6)       <interrupt> : extra timer interrupt

unfortunately you don't give more than the first line ;-(



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
