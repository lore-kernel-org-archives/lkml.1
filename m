Return-Path: <linux-kernel-owner+w=401wt.eu-S932757AbXAaDsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757AbXAaDsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 22:48:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932772AbXAaDro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 22:47:44 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:1504 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932839AbXAaDrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 22:47:33 -0500
Message-Id: <20070131033710.420168478@mvista.com>
User-Agent: quilt/0.46.mv-1
Date: Tue, 30 Jan 2007 19:37:10 -0800
From: Daniel Walker <dwalker@mvista.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com
Subject: [PATCH 00/23] clocksource update v12
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This tree is mostly cleanups . I move timekeeping code into it's own 
file, and I modify the clocksource interface to provide a more robust
API.

I've dropped some duplication off the hrt/dynamic tick patch set which
is all new to that tree and new to -mm. This is an -mm patch set , it's
not meant to go on 2.6.20-rc6 at all .. I'm modifying code only
included in -mm.

I boot tested x86_64 smp, and i386 smp, and compile tested for ARM
(!GENERIC_TIME). This set should be bisect-able for at least i386 and
likely x86_64.

It's also available at,

ftp://source.mvista.com/pub/dwalker/clocksource/clocksource-v12/

Daniel
-- 
