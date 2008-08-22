Return-Path: <linux-kernel-owner+w=401wt.eu-S1754293AbYHVN44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbYHVN44 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 09:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbYHVN4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 09:56:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55375 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752428AbYHVN4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 09:56:45 -0400
Message-ID: <48AEC58A.4010504@linux-foundation.org>
Date: Fri, 22 Aug 2008 08:56:26 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Robin Holt <holt@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       tokunaga.keiich@jp.fujitsu.com
Subject: Re: [RFC][PATCH 1/2] Show quicklist at meminfo
References: <20080820113559.f559a411.akpm@linux-foundation.org> <2f11576a0808210036icd9b61eue58049f15381bcc8@mail.gmail.com> <20080822100049.F562.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080821212847.f7fc936b.akpm@linux-foundation.org> <20080822132309.GB9501@sgi.com>
In-Reply-To: <20080822132309.GB9501@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Holt wrote:
> 
> Could we maybe add a per_cpu off-node quicklist and just always free
> that in check_pgt_cache?  That would get us back the freeing of off-node
> page tables.

Yes that is what I suggested and if you check your email from last year then
you will find an internal discussion and patches for such an approach.
