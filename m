Return-Path: <linux-kernel-owner+w=401wt.eu-S1753606Ab0AMMmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab0AMMmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 07:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091Ab0AMMmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 07:42:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44617 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402Ab0AMMml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 07:42:41 -0500
Message-ID: <4B4DBFBC.4090400@suse.de>
Date: Wed, 13 Jan 2010 13:42:36 +0100
From: Thomas Renninger <trenn@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUGFIX] cpufreq: dont BUG_ON uninitialized policy cpu
References: <20100113051438.GA32519@localhost>
In-Reply-To: <20100113051438.GA32519@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2010 06:14 AM, Wu Fengguang wrote:
> Remove a BUG_ON which is always triggered here after commit 0b19a310eebb93:
The patch got dropped from -mm.
I hope it did not make it upstream yet, otherwise it should also
get dropped/reverted there without replacement.
There wasn't a real, only a theoretical issue.
Looking at it again, I now think it's not needed at all.

    Thomas
