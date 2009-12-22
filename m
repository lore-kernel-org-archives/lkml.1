Return-Path: <linux-kernel-owner+w=401wt.eu-S1753845AbZLVP5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbZLVP5b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 10:57:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753801AbZLVP5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 10:57:30 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:49422 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709AbZLVP53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 10:57:29 -0500
Date: Tue, 22 Dec 2009 09:56:25 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V8 09/16] Allow arch to provide inc/dec functionality
 for each size separately
In-Reply-To: <4B2F2305.8030001@kernel.org>
Message-ID: <alpine.DEB.2.00.0912220955010.12163@router.home>
References: <20091218222617.384355422@quilx.com> <20091218222652.446462888@quilx.com> <4B2F2305.8030001@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Dec 2009, Tejun Heo wrote:

> On 12/19/2009 07:26 AM, Christoph Lameter wrote:
> > Current this_cpu ops only allow an arch to specify add RMW operations or inc
> > and dec for all sizes. Some arches can do more efficient inc and dec
> > operations. Allow size specific override of fallback functions like with
> > the other operations.
>
> Wouldn't it be better to use __builtin_constant_p() and switching in
> arch add/dec macros?  It just seems a bit extreme to define all those

Yes that could be done but I am on vacation till next year ;-)...

