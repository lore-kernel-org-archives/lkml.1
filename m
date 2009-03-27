Return-Path: <linux-kernel-owner+w=401wt.eu-S1763301AbZC0UOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763301AbZC0UOt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 16:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760447AbZC0UNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 16:13:49 -0400
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:55815 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763235AbZC0UNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 16:13:48 -0400
From: Frans Pop <elendil@planet.nl>
To: Santiago Garcia Mantinan <manty@manty.net>
Subject: Re: uli526x hangs on 2.6.29, not on rc8
Date: Fri, 27 Mar 2009 21:13:43 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <20090326231515.GA6612@dis.manty.net> <200903270102.00104.elendil@planet.nl> <20090327180458.GA4459@dis.manty.net>
In-Reply-To: <20090327180458.GA4459@dis.manty.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903272113.45324.elendil@planet.nl>
X-OriginalArrivalTime: 27 Mar 2009 20:13:45.0870 (UTC) FILETIME=[885DE2E0:01C9AF18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 March 2009, Santiago Garcia Mantinan wrote:
> > Known issue probably. Try: http://lkml.org/lkml/2009/3/25/217
>
> Yes, seems related, I'm testing that patch right now on my machine, but
> I'm wondering if I should test that one or this one
> (http://www.spinics.net/lists/netdev/msg92829.html) sent also by
> Herbert to the netdev list but at a later time.  I'll try test the
> second one also just in case.

No, the plain revert is safer.

If you want to test another patch, you should probably try this one 
instead, which AFAIK is the best real fix available:
http://lkml.org/lkml/2009/3/26/79

Cheers,
FJP
