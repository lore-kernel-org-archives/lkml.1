Return-Path: <linux-kernel-owner+w=401wt.eu-S1761335AbZDGUwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761335AbZDGUwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 16:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755935AbZDGUwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 16:52:36 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:56743 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620AbZDGUwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 16:52:35 -0400
Message-ID: <49DBBC1F.6000407@cs.helsinki.fi>
Date: Tue, 07 Apr 2009 23:48:31 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] slub: default min_partial to at least highest cpus per
  node
References: <alpine.DEB.2.00.0904051653420.25339@chino.kir.corp.google.com>  <49DBA23A.3000106@cs.helsinki.fi> <84144f020904071209j638aae9bv406661ec401af7af@mail.gmail.com> <alpine.DEB.2.00.0904071231500.21113@chino.kir.corp.google.com> <49DBAF7E.30704@cs.helsinki.fi> <alpine.DEB.2.00.0904071302430.32321@chino.kir.corp.google.com> <49DBB373.5050800@cs.helsinki.fi> <alpine.DEB.2.00.0904071316460.21748@chino.kir.corp.google.com> <49DBB929.4080205@cs.helsinki.fi> <alpine.DEB.1.10.0904071641390.12192@qirst.com>
In-Reply-To: <alpine.DEB.1.10.0904071641390.12192@qirst.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> I am not sure about the benefit of this. If the page allocator finally
> improves in performance then we can reduce the mininum number of partial
> slabs kept and also do pass through for all sizes >2k.

Sure, we can do that, but it still makes sense to adjust the partial 
list sizes based on per-node CPU count. So I'm inclined to apply the 
patch I suggested if it shows performance gains on one or more of the 
relevant benchmarks (sysbench, tbench, hackbench, netperf, etc.).
