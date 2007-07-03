Return-Path: <linux-kernel-owner+w=401wt.eu-S1760768AbXGCU1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760768AbXGCU1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 16:27:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757225AbXGCU0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 16:26:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:29551 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757859AbXGCU0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 16:26:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=AsJj5o4gBu0e+JqReUf+qfMvLg8k8O/EXyJqi3PKRiGQ8xtTC73g2n2DuNOtWyOI0iZvtFGpIOEBOBYduno8sES7H0GzGKBHuaX93G9AzagzrdeZd7oLbC4YQnyjL7oDymrqB3Pz253u4iKkQoGKhTFLBtJ2aDzk4ex9Ygu4S6E=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linas Vepstas <linas@austin.ibm.com>
Subject: Re: [PATCH pata-2.6 fix] hpt366: use correct enablebits for HPT36x
Date: Tue, 3 Jul 2007 21:06:59 +0200
User-Agent: KMail/1.9.6
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, michal.kepien@poczta.onet.pl,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200706300004.22274.sshtylyov@ru.mvista.com> <20070703162641.GA4302@austin.ibm.com>
In-Reply-To: <20070703162641.GA4302@austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707032107.00131.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 July 2007, Linas Vepstas wrote:
> Hi,
> 
> On Sat, Jun 30, 2007 at 12:04:22AM +0400, Sergei Shtylyov wrote:
> > The HPT36x chips finally turned out to have the channel enable bits -- however,
> > badly implemented.  Make use of them despite it's probably only going to burden
> > the driver's code -- assuming both channels are always enabled by the HighPoint
> > BIOS anyway...
> > 
> > Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> > 
> > ---
> > Michal, Linas, please verify the patch... :-)
> 
> No negative impact for me.
> 
> (Am I supposed to acked-by if I do this kind of review/test?)

added your ACK also for this patch

Bart
