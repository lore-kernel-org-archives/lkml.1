Return-Path: <linux-kernel-owner+w=401wt.eu-S1754488Ab0AEPWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488Ab0AEPWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 10:22:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754339Ab0AEPWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 10:22:36 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:37981 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377Ab0AEPWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 10:22:35 -0500
Date: Tue, 5 Jan 2010 09:21:18 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V9 4/7] Generic inc / dec percpu instructions
In-Reply-To: <4B4293A3.10106@kernel.org>
Message-ID: <alpine.DEB.2.00.1001050919570.1074@router.home>
References: <20100104223439.228028923@quilx.com> <20100104223556.090044300@quilx.com> <4B4293A3.10106@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jan 2010, Tejun Heo wrote:

> According to gcc doc, __builtin_constant_p() returns 1 on constant and
> 0 if not.  It doesn't return the original expression.  I'll commit the
> following updated version after testing.

Great. Thanks. That means that most of the percpu uses currently are incs
and decs not adds. Machine worked fine with the buggy patch.
