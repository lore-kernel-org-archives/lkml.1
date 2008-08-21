Return-Path: <linux-kernel-owner+w=401wt.eu-S1758675AbYHUGss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675AbYHUGss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 02:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757919AbYHUGrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 02:47:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53766 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757799AbYHUGrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 02:47:16 -0400
Date: Wed, 20 Aug 2008 23:46:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       tokunaga.keiich@jp.fujitsu.com
Subject: Re: [RFC][PATCH 2/2] quicklist shouldn't be proportional to # of
 CPUs
Message-Id: <20080820234615.258a9c04.akpm@linux-foundation.org>
In-Reply-To: <20080820200709.12F0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080820195021.12E7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080820200709.12F0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2008 20:08:13 +0900 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> +	num_cpus_per_node = cpus_weight_nr(node_to_cpumask(node));

sparc64 allmodconfig:

mm/quicklist.c: In function `max_pages':
mm/quicklist.c:44: error: invalid lvalue in unary `&'

we seem to have a made a spectacular mess of cpumasks lately.
