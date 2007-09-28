Return-Path: <linux-kernel-owner+w=401wt.eu-S1758211AbXI1EwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211AbXI1EwG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 00:52:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbXI1Evy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 00:51:54 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51117 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbXI1Evw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 00:51:52 -0400
Date: Fri, 28 Sep 2007 13:52:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [13/17] Virtual compound page freeing in interrupt context
Message-Id: <20070928135255.80dd7575.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070925234252.220601640@sgi.com>
References: <20070925234204.546836393@sgi.com>
	<20070925234252.220601640@sgi.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2007 16:42:17 -0700
Christoph Lameter <clameter@sgi.com> wrote:

> +static noinline void vcompound_free(void *addr)
> +{
> +	if (in_interrupt()) {

Should be (in_interrupt() || irqs_disabled()) ?

Regards,
-Kame

