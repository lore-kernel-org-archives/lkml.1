Return-Path: <linux-kernel-owner+w=401wt.eu-S1763259AbXJEQ2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763259AbXJEQ2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 12:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932069AbXJEQ1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 12:27:37 -0400
Received: from mail.gmx.net ([213.165.64.20]:58963 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1761376AbXJEQ1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 12:27:35 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18LbocUGCoL2tY4/4CXkKoRLc/fTSBOCoy0p8XM4t
	XQeI26PU73XHow
Date: Fri, 5 Oct 2007 18:27:54 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [Q] APM depends on PM_SLEEP?
In-Reply-To: <200710051749.52685.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.60.0710051827020.10392@poirot.grange>
References: <Pine.LNX.4.60.0710051615350.10392@poirot.grange>
 <200710051749.52685.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Oct 2007, Rafael J. Wysocki wrote:

> On Friday, 5 October 2007 16:18, Guennadi Liakhovetski wrote:
> > Why does APM depend on PM_SLEEP?
> 
> Because APM uses the suspend core functions in drivers/base/power .

Ok, perhaps, a "select" would be better?...

Thanks
Guennadi
---
Guennadi Liakhovetski
