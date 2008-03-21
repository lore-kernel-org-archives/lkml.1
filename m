Return-Path: <linux-kernel-owner+w=401wt.eu-S1756223AbYCUByc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbYCUByc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 21:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbYCUByX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 21:54:23 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2998 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbYCUByX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 21:54:23 -0400
Subject: Re: [PATCH] Add definitions of USHRT_MAX
From: Joe Perches <joe@perches.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <clameter@sgi.com>,
       linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1206063614.14496.72.camel@ymzhang>
References: <1206063614.14496.72.camel@ymzhang>
Content-Type: text/plain
Date: Thu, 20 Mar 2008 18:51:18 -0700
Message-Id: <1206064278.26345.108.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-21 at 09:40 +0800, Zhang, Yanmin wrote:
> Add definitions of USHRT_MAX and others into kernel. ipc uses it and
> slub implementation might also use it.
> +#define USHRT_MAX	((u16)(~0U))
> +#define SHRT_MAX	((s16)(USHRT_MAX>>1))
> +#define SHRT_MIN	(-SHRT_MAX - 1)

Perhaps it's better to use the most common kernel types?
Perhaps U16_MAX, S16_MAX and S16_MIN?

Don't you need to cast SHRT_MIN/S16_MIN too?
#define S16_MIN ((s16)(-SHRT_MAX - 1))

