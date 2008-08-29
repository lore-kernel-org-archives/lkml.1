Return-Path: <linux-kernel-owner+w=401wt.eu-S1755583AbYH2AWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583AbYH2AWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 20:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755227AbYH2AWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 20:22:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59202 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753591AbYH2AWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 20:22:20 -0400
Date: Thu, 28 Aug 2008 17:22:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org, Stefan.Becker@nokia.com, rjw@sisk.pl
Subject: Re: [patch 2.6.27-rc4] rtc-cmos: wakes again from S5
Message-Id: <20080828172206.5e083817.akpm@linux-foundation.org>
In-Reply-To: <200808281129.35611.david-b@pacbell.net>
References: <200808281129.35611.david-b@pacbell.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2008 11:29:35 -0700
David Brownell <david-b@pacbell.net> wrote:

> +	if (system_state == SYSTEM_POWER_OFF && !cmos_poweroff(pdev))

erp, system_state is a pretty horrid thing.  It's a global with
relatively poorly defined transition conditions which have actually
changed over time.

It was not my greatest ever idea.  It was simple and expedient at the
time and expanded use of it was "discouraged" (rofl).

Is there no alternative?
