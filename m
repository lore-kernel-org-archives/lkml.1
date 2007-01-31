Return-Path: <linux-kernel-owner+w=401wt.eu-S964819AbXAaPJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964819AbXAaPJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 10:09:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964812AbXAaPJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 10:09:17 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:13582 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964976AbXAaPJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 10:09:16 -0500
Subject: Re: [PATCH 07/23] clocksource: rating sorted list
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070131093414.GA21335@elte.hu>
References: <20070131033710.420168478@mvista.com>
	 <20070131033805.183466048@mvista.com>  <20070131093414.GA21335@elte.hu>
Content-Type: text/plain
Date: Wed, 31 Jan 2007 07:07:45 -0800
Message-Id: <1170256065.9781.19.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-31 at 10:34 +0100, Ingo Molnar wrote:

> a rating change can occur due to other things as well, not only due to 
> 'tsc unstable' events. So keeping an API around that changes the rating 
> (and propagates all related changes), makes more sense to me.
> 
> also, a pure function call is the most natural (and most flexible) API, 
> for a centrally registered resource like a clock source driver. And a 
> rating change should imply a reselect too, obviously. That way we 
> replace 2 lines with 1 line - that's a real API improvement and a real 
> cleanup patch.
> 
> and that's precisely what Thomas' patch in -mm that your queue undoes 
> implements. (see: simplify-the-registration-of-clocksources.patch in 
> -mm) Have you considered Thomas' change when you dropped it?

My patch set makes clocksource ratings constant (when fully applied).
That particular function is dropped all together .

Daniel

