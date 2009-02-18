Return-Path: <linux-kernel-owner+w=401wt.eu-S1754515AbZBREyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbZBREyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 23:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbZBREyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 23:54:12 -0500
Received: from mail.gmx.net ([213.165.64.20]:49235 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751319AbZBREyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 23:54:12 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1805uVtxBc07hMg44DFTewCzn8cP/Z/PkcjT48ajZ
	vVB0DsQZ2C9C8k
Subject: Re: 2.6.29-rc4 regression
From: Mike Galbraith <efault@gmx.de>
To: Tim Blechmann <tim@klingt.org>
Cc: Robert Richter <robert.richter@amd.com>, oprofile-list@lists.sf.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <499B3271.6020306@klingt.org>
References: <1229869416.6911.1.camel@thinkpad> <49932C35.3020300@klingt.org>
	 <20090213190740.GD25042@erda.amd.com> <20090216112313.359ef437@thinkpad>
	 <20090216113349.GF25042@erda.amd.com>  <499961AF.8030909@klingt.org>
	 <1234856740.6867.22.camel@marge.simson.net>  <499B3271.6020306@klingt.org>
Content-Type: text/plain
Date: Wed, 18 Feb 2009 05:54:07 +0100
Message-Id: <1234932847.5257.8.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-17 at 22:56 +0100, Tim Blechmann wrote:
> >> hm, i just tried to compile 2.6.28 with this patch applied, and there
> >> the NMIs are delivered correctly.
> >>
> >>> Thanks Tim, on later kernels, is it the behaviour you mentioned that
> >>> no NMIs are delivered and you do not receive any NMI?
> >> on the current 2.6.29-rc5, no NMIs are delivered. however i have also
> >> applied the performance counter branch from tip, maybe that interferes
> >> with oprofile?
> > 
> > Hm.
> > 
> > If you're using latest tip, there _should_ be no interference.  There
> > was a problem a short while back in that both perfcounters and oprofile
> > register die handlers, but that was resolved by increasing oprofile's
> > handler priority, so that it takes over NMI handling while profiling.
> 
> well, it seems to be a perfcounters vs. oprofile issue. when i applied
> the patch i posted earlier onto vanilla 2.6.29-rc5, NMIs were delivered ...

Ok, I replied wrt the perfcounters _branch_ you added, and NMI delivery.

	-Mike

