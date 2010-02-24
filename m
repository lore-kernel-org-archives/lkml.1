Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab0BXJQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 04:16:27 -0500
Received: from ernst.netinsight.se ([194.16.221.21]:54096 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755316Ab0BXJQ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 04:16:26 -0500
Date: Wed, 24 Feb 2010 10:16:18 +0100
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: =?ISO-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Cc: linux-kernel@vger.kernel.org, wim@iguana.be, seth.heasley@intel.com
Subject: Re: [PATCH] iTCO_wdt: Don't double the requested timeout
Message-ID: <20100224101618.39c3468b@marrow.netinsight.se>
In-Reply-To: <4B840BC6.9090809@draigBrady.com>
References: <20100223164019.60a6de1a@marrow.netinsight.se>
	<4B840154.1010501@draigBrady.com>
	<4B840BC6.9090809@draigBrady.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Feb 2010 17:09:26 +0000
Pádraig Brady <P@draigBrady.com> wrote:

> Actually looking at that code I noticed that it wasn't
> accounting for the timer counting down twice before reboot,
> which I thought was the case for ICH4 at least.
> The following is not even compiled, nor am I sure it
> applies to TCO v2. Testing/info appreciated.

I tested your change on our TCO v1-based board, and it doubles the time
until the watchdog triggers. So:

Tested-by: Simon Kagstrom <simon.kagstrom@netinsight.se>
