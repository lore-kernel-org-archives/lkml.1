Return-Path: <linux-kernel-owner+w=401wt.eu-S1758713AbXGDIjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713AbXGDIjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 04:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756667AbXGDIjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 04:39:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:54260 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756359AbXGDIjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 04:39:10 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: 7091@blargh.com
Subject: Re: sata_sil, writing bug with multiple cards?
Date: Wed, 4 Jul 2007 10:38:57 +0200
User-Agent: KMail/1.9.6
Cc: Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org, jgarzik@pobox.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <courier.4689EFD9.0000589A@blargh.com> <200707040908.21512.ak@suse.de> <courier.468B579E.00002ECF@blargh.com>
In-Reply-To: <courier.468B579E.00002ECF@blargh.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707041038.57677.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 July 2007 10:17:34 7091@blargh.com wrote:

> > Most likely it is some sort of hardware bug that we might
> > not be able to do much about. Have you tried contacting SIL or VIA? 
> 
> No, I haven't.  Like I mentioned above, the OpenBSD drivers seemed to work, 
> or at least did with similar tests.  I would need to run the more extensive 
> checks to be positive, but those take a lot of time, obviously.  And 
> downtime for the box, a lot of which isn't really manageable, at the moment. 

Perhaps the OpenBSD drivers program the SIL chip in a different way
that avoids this problem. 

> 
> > e.g. if you have some other system with a different chipset it might
> > be useful to test the SIL controllers in those.
> 
> The previous motherboard was an AMD 760 chipset, and it had the same 
> problem. 

Ok this means it's likely a SIL issue, not a chipset issue.

-Andi
