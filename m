Return-Path: <linux-kernel-owner+w=401wt.eu-S1763211AbZEHOS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763211AbZEHOS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 10:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbZEHOSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 10:18:16 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:60107 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754285AbZEHOSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 10:18:16 -0400
Date: Fri, 8 May 2009 10:17:43 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu, mel@csn.ul.ie,
       linux-kernel@vger.kernel.org, riel@redhat.com, rientjes@google.com,
       xemul@openvz.org
Subject: Re: [RFC/PATCH v2] mm: Introduce GFP_PANIC for non-failing
 allocations
In-Reply-To: <1241790607.28600.36.camel@penberg-laptop>
Message-ID: <alpine.DEB.1.10.0905081017180.23875@qirst.com>
References: <20090504122740.GH4173@lenovo> <20090504131311.GA23330@elte.hu>  <20090504131638.GJ4173@lenovo>  <alpine.DEB.1.10.0905040940490.9553@qirst.com>  <20090504115335.9bc08587.akpm@linux-foundation.org>  <20090504192117.GB31176@lenovo> 
 <20090504123453.d130a6cf.akpm@linux-foundation.org>  <20090504200925.GD31176@lenovo> <1241787448.28600.26.camel@penberg-laptop>  <20090508133704.GE6132@lenovo> <1241790607.28600.36.camel@penberg-laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 May 2009, Pekka Enberg wrote:

> There are such BUG_ONs in SLUB, for example, and probably elsewhere in
> early-boot code.

Thus Pekka's patch would allow us to reduce code in all these cases.

