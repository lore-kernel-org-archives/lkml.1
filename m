Return-Path: <linux-kernel-owner+w=401wt.eu-S1031027AbXEDQFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031027AbXEDQFg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 12:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031035AbXEDQFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 12:05:35 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53395 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031039AbXEDQFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 12:05:34 -0400
Date: Fri, 4 May 2007 09:05:32 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: William Lee Irwin III <wli@holomorphy.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Remove constructor from buffer_head
In-Reply-To: <20070504063534.GX19966@holomorphy.com>
Message-ID: <Pine.LNX.4.64.0705040905020.21436@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0705032007540.16627@schroedinger.engr.sgi.com>
 <20070504063534.GX19966@holomorphy.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2007, William Lee Irwin III wrote:

> On Thu, May 03, 2007 at 08:08:41PM -0700, Christoph Lameter wrote:
> > Performance tests show a slight improvements in netperf (not a
> > strong case for a performance improvement but removing the
> > constructor has definitely no negative impact so why keep
> > this around?).
> 
> Cache effects are not so easily visible. Cache profile results from
> more realistic workloads (e.g. major macrobenchmarks) are more
> appropriate for gauging this.

Yeah I really out to stick a performance counter in this but that would 
require some effort. Defer for now I guess.

