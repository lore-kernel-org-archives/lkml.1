Return-Path: <linux-kernel-owner+w=401wt.eu-S1759425AbXGCQ0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425AbXGCQ0w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 12:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755856AbXGCQ0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 12:26:44 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:52720 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755580AbXGCQ0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 12:26:43 -0400
Date: Tue, 3 Jul 2007 11:26:41 -0500
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: bzolnier@gmail.com, michal.kepien@poczta.onet.pl,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH pata-2.6 fix] hpt366: use correct enablebits for HPT36x
Message-ID: <20070703162641.GA4302@austin.ibm.com>
References: <200706300004.22274.sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706300004.22274.sshtylyov@ru.mvista.com>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Jun 30, 2007 at 12:04:22AM +0400, Sergei Shtylyov wrote:
> The HPT36x chips finally turned out to have the channel enable bits -- however,
> badly implemented.  Make use of them despite it's probably only going to burden
> the driver's code -- assuming both channels are always enabled by the HighPoint
> BIOS anyway...
> 
> Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> 
> ---
> Michal, Linas, please verify the patch... :-)

No negative impact for me.

(Am I supposed to acked-by if I do this kind of review/test?)

--linas
