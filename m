Return-Path: <linux-kernel-owner+w=401wt.eu-S1753376AbZDVOhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbZDVOhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 10:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbZDVOhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 10:37:40 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:55764 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbZDVOhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 10:37:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ZpElngXPH3NWXqJnZ0kUzmNvn5QPzUEj+TZstnofhqdNy13EjfWhuYnLKVRA7Ymd3s
         BdmvL0zyX4GGKBdZ+XiJJL54z0zEFk9oNHk8MrHf94szJ2kx8MMvBBtU4xqdbXB3pMfU
         Mmaeom1Swjcdb5KgYyc9POjtk1gbty8+28wN0=
MIME-Version: 1.0
In-Reply-To: <1240408407-21848-23-git-send-email-mel@csn.ul.ie>
References: <1240408407-21848-1-git-send-email-mel@csn.ul.ie>
	 <1240408407-21848-23-git-send-email-mel@csn.ul.ie>
Date: Wed, 22 Apr 2009 17:37:38 +0300
X-Google-Sender-Auth: 615cf53c0e95c90a
Message-ID: <84144f020904220737t3657ac01j4edf86cf61ef15e0@mail.gmail.com>
Subject: Re: [PATCH 22/22] slab: Use nr_online_nodes to check for a NUMA 
	platform
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 4:53 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> SLAB currently avoids checking a bitmap repeatedly by checking once and
> storing a flag. When the addition of nr_online_nodes as a cheaper version
> of num_online_nodes(), this check can be replaced by nr_online_nodes.
>
> (Christoph did a patch that this is lifted almost verbatim from, hence the
> first Signed-off-by. Christoph, can you confirm you're ok with that?)
>
> Signed-off-by: Christoph Lameter <cl@linux.com>
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
