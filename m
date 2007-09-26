Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbXIZXnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbXIZXnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 19:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbXIZXnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 19:43:12 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:20741 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbXIZXnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 19:43:12 -0400
Date: Wed, 26 Sep 2007 16:41:59 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: mgross@linux.intel.com
Cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] QoS params patch
Message-Id: <20070926164159.3b43479b.randy.dunlap@oracle.com>
In-Reply-To: <20070926224026.GA23218@linux.intel.com>
References: <20070926223712.GA22029@linux.intel.com>
	<20070926224026.GA23218@linux.intel.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2007 15:40:26 -0700 Mark Gross wrote:

> The following is the qos_param patch that implements a genralization of
> latency.c.
> 

Just some general comments (as on irc):

- use 'diffstat -p1 -w70' to summarize each patch
- use checkpatch.pl to check for coding style and other buglets
- has no API docs  :(




> +/* assumes qos_lock is held */
> +static void update_target(int i)

I'd prefer a better arg name than 'i'.

> +{

---
~Randy
Phaedrus says that Quality is about caring.
