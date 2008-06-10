Return-Path: <linux-kernel-owner+w=401wt.eu-S1753889AbYFJWZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbYFJWZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 18:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbYFJWZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 18:25:05 -0400
Received: from main.gmane.org ([80.91.229.2]:54426 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444AbYFJWZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 18:25:03 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: DEBUG_LOCK_ALLOC causes hostap kernel lockup
Followup-To: gmane.linux.kernel
Date: Tue, 10 Jun 2008 23:16:13 +0100
Message-ID: <g2mufc$c16$1@ger.gmane.org>
References: <g2760n$7f0$1@ger.gmane.org> <g2la7s$g8r$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cpc1-cwma5-0-0-cust137.swan.cable.ntl.com
User-Agent: KNode/0.10.4
Cc: kernel-testers@vger.kernel.org, linux-wireless@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sitsofe Wheeler wrote:

> Sitsofe Wheeler wrote:
> 
>> hostap_pci on a 32bit x86 machine seems to be unstable under load in
>> next-20080604. Using iperf between a wired machine on the other side of
>> the AP and the hostap box makes hostap output the message
>> wifi0: SW TICK stuck? bits=0x0 EvStat=8000 IntEn=e09f
>> before things slowly grind to a halt in a lockup that seemingly needs a
> 
> things always seem to be recoverable. Sometimes the system will recover
> after the lockup with a message like:
> Clocksource tsc unstable (delta = 9377016871 ns)
> Time acpi_pm clocksource has been installed.

The lockups seem to be down to DEBUG_LOCK_ALLOC (Lock debugging: detect
incorrect freeing of live locks). If that is enabled then after enough
iperf runs the kernel will lock solid. This problems seems to happen in
kernels from at least 2.6.22 onwards.

I had no idea that enabling lock checking could itself result in a lockup...

-- 
Sitsofe | http://sucs.org/~sits/

