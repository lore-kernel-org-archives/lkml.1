Return-Path: <linux-kernel-owner+w=401wt.eu-S1755153AbZISVo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153AbZISVo5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755121AbZISVoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:44:55 -0400
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:54491 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754456AbZISVox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:44:53 -0400
From: Frans Pop <elendil@planet.nl>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: Hibernation oops with 2.6.31 won't fit the screen - how to debug?
Date: Sat, 19 Sep 2009 23:44:54 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200909192155.01225.linux@rainbow-software.org>
In-reply-To: <200909192155.01225.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909192344.55258.elendil@planet.nl>
X-OriginalArrivalTime: 19 Sep 2009 21:44:55.0627 (UTC) FILETIME=[6D4C91B0:01CA3972]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ondrej Zary wrote:
> hibernation worked great with 2.6.30 - I had over a month of uptime (it
> never worked so well before - always crashed after some time). But in
> 2.6.31, it's broken again - and completely. The first hibernation works
> but it always crashes on the second one.
> 
> The problem is that the oops is so long that it does not fit the screen -
> even 1280x1024 is not enough. Scrolling does not work (as it used to do
> on 2.4 kernels), netconsole does not catch it. So how can I debug this?

One way to get at least an indication of what broke the hibernation is to 
run a bisection to find the change that broke hibernation. That could 
provide sufficient clues for a next step.

Would that be an option for you?

Cheers,
FJP
