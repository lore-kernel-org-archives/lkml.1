Return-Path: <linux-kernel-owner+w=401wt.eu-S1754759AbZENTp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbZENTp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 15:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbZENTpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 15:45:17 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:54083 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753225AbZENTpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 15:45:16 -0400
Date: Thu, 14 May 2009 15:44:46 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Yinghai Lu <yinghai@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, mel@csn.ul.ie, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, suresh.b.siddha@intel.com,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       rusty@rustcorp.com.au, steiner@sgi.com, rientjes@google.com
Subject: Re: [PATCH 5/5] mm: clear N_HIGH_MEMORY map before se set it again
 -v2
In-Reply-To: <4A0C563A.3020100@kernel.org>
Message-ID: <alpine.DEB.1.10.0905141543280.1381@qirst.com>
References: <4A05269D.8000701@kernel.org> <20090512111623.GG25923@csn.ul.ie> <4A0A64FB.4080504@kernel.org> <20090513145950.GB28097@csn.ul.ie> <4A0C4910.7090508@kernel.org> <4A0C4A2A.6080009@kernel.org> <20090514095414.ba8356e5.akpm@linux-foundation.org>
 <4A0C4F67.5080802@kernel.org> <20090514102554.b3a36f19.akpm@linux-foundation.org> <4A0C563A.3020100@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 May 2009, Yinghai Lu wrote:

> > Put yourself in the position of a distro engineer whose customer
> > reports a 2.6.26 problem.  He's going to look at your patch wondering
> > whether it might fix his customer's problem.  We should provide him
> > with sufficient information to be able to determine this.

PowerPC has similar node 0 issues that have thrown us for a curve once in
awhile. Now they are coming to x86.
