Return-Path: <linux-kernel-owner+w=401wt.eu-S1758888AbXI1GZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758888AbXI1GZS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 02:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755157AbXI1GZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 02:25:06 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52133 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753694AbXI1GZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 02:25:04 -0400
Date: Thu, 27 Sep 2007 23:25:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: mgross@linux.intel.com
Cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] QoS params patch
Message-Id: <20070927232501.79f9f4bd.akpm@linux-foundation.org>
In-Reply-To: <20070926224026.GA23218@linux.intel.com>
References: <20070926223712.GA22029@linux.intel.com>
	<20070926224026.GA23218@linux.intel.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2007 15:40:26 -0700 Mark Gross <mgross@linux.intel.com> wrote:

> +#define QOS_RESERVED 0
> +#define QOS_CPU_DMA_LATENCY 1
> +#define QOS_NETWORK_LATENCY 2
> +#define QOS_NETWORK_THROUGHPUT 3
> +
> +#define QOS_NUM_CLASSES 4
> +#define QOS_DEFAULT_VALUE -1
> +
> +int qos_add_requirement(int qos, char *name, s32 value);
> +int qos_update_requirement(int qos, char *name, s32 new_value);
> +void qos_remove_requirement(int qos, char *name);

It's a bit rude stealing the entire "qos" namespace like this - there are
many different forms of QoS, some already in-kernel.

s/qos/pm_qos/g ?
