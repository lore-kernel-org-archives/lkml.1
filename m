Return-Path: <linux-kernel-owner+w=401wt.eu-S1756951AbXI2DFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951AbXI2DFb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 23:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958AbXI2DFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 23:05:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43353 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbXI2DFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 23:05:24 -0400
Message-ID: <46FDC0EB.3070003@zytor.com>
Date: Fri, 28 Sep 2007 20:05:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: regression in 2.6.23-rc8 - power off failed
References: <20070929005453.GA4475@erig.dyndns.org>
In-Reply-To: <20070929005453.GA4475@erig.dyndns.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfgang Erig wrote:
> Hi,
> 
> the latest kernel does not power off my system.
> 
> 2.6.22 succeeded
> 2.6.23-rc8 failed
> 
> $ git bisect bad  
> Bisecting: 0 revisions left to test after this 
> [f216cc3748a3a22c2b99390fddcdafa0583791a2] ACPI: suspend: consolidate handling of Sx states.
> 
> $ git bisect good 
> Bisecting: 0 revisions left to test after this 
> [626073132b381684c4983e0d911e9aceb32e2cbc] Assembly header and main routine for new x86 setup code 

OK, so which one is the bad one?

	-hpa

