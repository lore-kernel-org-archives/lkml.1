Return-Path: <linux-kernel-owner+w=401wt.eu-S1756214AbZHMUfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbZHMUfm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756179AbZHMUfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:35:41 -0400
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:52029 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755554AbZHMUfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 16:35:39 -0400
From: Frans Pop <elendil@planet.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Regression] PCI resources allocation problem on HP nx6325
Date: Thu, 13 Aug 2009 22:35:36 +0200
User-Agent: KMail/1.9.9
Cc: mano@roarinelk.homelinux.net, rjw@sisk.pl, willy@linux.intel.com,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       akpm@linux-foundation.org, andrew.patterson@hp.com
References: <200908021619.48285.rjw@sisk.pl> <200908132128.31439.elendil@planet.nl> <alpine.LFD.2.01.0908131244280.28882@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0908131244280.28882@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908132235.39171.elendil@planet.nl>
X-OriginalArrivalTime: 13 Aug 2009 20:35:39.0688 (UTC) FILETIME=[9EE1DA80:01CA1C55]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 August 2009, Linus Torvalds wrote:
> On Thu, 13 Aug 2009, Frans Pop wrote:
> > It's never resulted in things not working, but it would still be nice
> > if it got solved. Please let me know if you'd like anything tested.
>
> Did you test the trial-balloon patch I sent to Manuel?

I had not, but I've tried it now. And it does not change anything: the 
errors are still there. So it probably isn't the same issue after all.

I'll try to find out exactly which commits made the errors go away 
with .31-rc2 and reappear with .31-rc5.
