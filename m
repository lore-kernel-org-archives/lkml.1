Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838AbYATLfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbYATLfA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 06:35:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbYATLev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 06:34:51 -0500
Received: from main.gmane.org ([80.91.229.2]:47012 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbYATLeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 06:34:50 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Helge Deller <deller@gmx.de>
Subject: Re: [patch 1/3] LatencyTOP infrastructure patch
Date: Sun, 20 Jan 2008 12:34:49 +0100
Message-ID: <fmvbkb$jmb$1@ger.gmane.org>
References: <4790E3A6.7060807@linux.intel.com> <20080118093943.0048d0f7@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: mnhm-590f6122.pool.einsundeins.de
User-Agent: KNode/0.10.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> [linux-2.6.24-rc7/include/linux/latencytop.h]
> +struct latency_entry {
> +     char    *reason;
>...
> +struct latency_record {
> +     char    *reason;
>...
> +struct latency_entry *set_latency_reason(char *reason,
>...

I'd propose to mark the "reason" entries above (and the others as well)
as "const char *", which would move the strings to the ro-data section.

Helge

