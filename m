Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbZENT5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbZENT5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 15:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbZENT5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 15:57:37 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:39738 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750906AbZENT5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 15:57:36 -0400
Date: Thu, 14 May 2009 15:57:32 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2/4] vmscan: drop PF_SWAPWRITE from zone_reclaim
In-Reply-To: <20090513120627.587F.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0905141553160.1381@qirst.com>
References: <20090513120155.5879.A69D9226@jp.fujitsu.com> <20090513120627.587F.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 May 2009, KOSAKI Motohiro wrote:

> Subject: [PATCH] vmscan: drop PF_SWAPWRITE from zone_reclaim
>
> PF_SWAPWRITE mean ignore write congestion. (see may_write_to_queue())
>
> foreground reclaim shouldn't ignore it because to write congested device cause
> large IO lantency.
> it isn't better than remote node allocation.

Zone reclaim by default does not perform writes. RECLAIM_WRITE must be set
for that to be effective.

Acked-by: Christoph Lameter <cl@linux-foundation.org>


