Return-Path: <linux-kernel-owner+w=401wt.eu-S1753768AbZLAMDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768AbZLAMDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 07:03:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbZLAMDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 07:03:24 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:51556 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900AbZLAMDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 07:03:23 -0500
Date: Tue, 1 Dec 2009 12:04:40 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Subject: Perf events/ARM
Message-ID: <20091201120439.GB4061@wear.picochip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm looking at adding support for the hardware performance counters in ARMv6
using the new perf events framework. I have a simple setup that uses the
counters on their own, but wrt the perf events framework:

	- what are the requirements of set_perf_event_pending() and
	perf_event_do_pending()? As far as I can tell from sparc/x86/powerpc,
	set_perf_event_pending() triggers an interrupt that then calls
	perf_event_do_pending(). Does perf_event_do_pending need to run in
	interrupt context or could I use a soft IRQ if platforms don't have a
	spare IRQ?

	- ARM does not have proper support for atomic64's. Other than
	performance, would there be any known problems with using the generic
	spinlocked atomic64's?

Thanks,

Jamie
