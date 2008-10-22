Return-Path: <linux-kernel-owner+w=401wt.eu-S1757686AbYJVSLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686AbYJVSLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 14:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757480AbYJVSLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 14:11:14 -0400
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:42253 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757391AbYJVSLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 14:11:13 -0400
Date: Wed, 22 Oct 2008 11:10:56 -0700 (PDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] SLUB - define OO_ macro instead of hardcoded numbers
In-Reply-To: <20081022175827.GL9639@localhost>
Message-ID: <Pine.LNX.4.64.0810221110060.27088@quilx.com>
References: <20081022161836.GG9639@localhost> <Pine.LNX.4.64.0810220926130.7633@quilx.com>
 <20081022163530.GH9639@localhost> <20081022165354.GI9639@localhost>
 <20081022172103.GJ9639@localhost> <Pine.LNX.4.64.0810221037320.7633@quilx.com>
 <48FF6800.20705@cs.helsinki.fi> <20081022175827.GL9639@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Spam-Score: -2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008, Cyrill Gorcunov wrote:

> +#define OO_SHIFT	16
> +#define OO_MASK		((1 << OO_SHIFT) - 1)
> +#define MAX_OBJS_PER_PAGE	65535 /* see struct page.objects */

This is == OO_MASK right? Otherwise things will break when we change 
OO_SHIFT.
