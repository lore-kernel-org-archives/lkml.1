Return-Path: <linux-kernel-owner+w=401wt.eu-S1757265AbYFNMbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265AbYFNMbt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 08:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752925AbYFNMbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 08:31:40 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:22045 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbYFNMbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 08:31:39 -0400
Date: Sat, 14 Jun 2008 14:34:35 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [UPDATED v3][PATCH 0/7] regulator: voltage and current
 regulator framework
Message-Id: <20080614143435.69f03d5d.krzysztof.h1@poczta.fm>
In-Reply-To: <1204827030.15360.146.camel@a10323.wolfsonmicro.main>
References: <1204827030.15360.146.camel@a10323.wolfsonmicro.main>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: 18e2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Mar 2008 18:10:30 +0000
Liam Girdwood <lg@opensource.wolfsonmicro.com> wrote:

> Updated with comments received from v2. I've also added more in code
> comments to hopefully make the review a little easier to read through.
> 
> This patch series provides a generic framework to allow device drivers
> to control voltage and current regulators on SoC based devices (e.g.
> phones, gps, media players).
> 

>  4. Userspace.
> 
>   The framework also exports a lot of useful voltage/current data to
> userspace via sysfs. This could be used to monitor device and regulator
> power and status.
> 

IMO, this work should be merged into kernel hwmon project. The hwmon
project has already sysfs API to read voltages and currents. Hwmon guys should
be able to extend the API to cover also possibility to change (set) voltages
and currents (as they do currently with fans).

The advantage is that monitoring of regulators (reading voltages and currents)
would be instantially supported by all existing lm-sensors tool.

You should send your patches to kernel hwmon list: lm-sensors@lm-sensors.org

Kind regards,
Krzysztof

----------------------------------------------------------------------
Gdzie warto jechac na urlop? Sprawdz!
kliknij >>> http://link.interia.pl/f1e32

