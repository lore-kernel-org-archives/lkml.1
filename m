Return-Path: <linux-kernel-owner+w=401wt.eu-S1759059AbZGGQdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759059AbZGGQdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 12:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757055AbZGGQdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 12:33:38 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:50852 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756478AbZGGQdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 12:33:37 -0400
Date: Tue, 7 Jul 2009 12:33:21 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 1/5] add per-zone statistics to show_free_areas()
In-Reply-To: <20090705182259.08F6.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0907071231220.5124@gentwo.org>
References: <20090705181400.08F1.A69D9226@jp.fujitsu.com> <20090705182259.08F6.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Jul 2009, KOSAKI Motohiro wrote:

> Subject: [PATCH] add per-zone statistics to show_free_areas()
>
> Currently, show_free_area() mainly display system memory usage. but it
> doesn't display per-zone memory usage information.

An attempt to rewrite the description:

show_free_areas() displays only a limited amount of zone counters. This
patch includes additional counters in the display to allow easier
debugging. This may be especially useful if an OOM is due to running out
of DMA memory.

Reviewed-by: Christoph Lameter <cl@linux-foundation.org>

