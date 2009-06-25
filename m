Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbZFYDpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbZFYDpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 23:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000AbZFYDpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 23:45:13 -0400
Received: from senator.holtmann.net ([87.106.208.187]:45411 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbZFYDpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 23:45:12 -0400
Subject: Re: question on A2DP sink suspend/resume
From: Marcel Holtmann <marcel@holtmann.org>
To: lan zhu <zhu.lan.cn@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <113d36d80906242033p134edf27t12bda1d0359c4134@mail.gmail.com>
References: <113d36d80906242033p134edf27t12bda1d0359c4134@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 25 Jun 2009 05:45:11 +0200
Message-Id: <1245901511.15367.150.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zhu,

> If we want to create SCO link when A2DP is in streaming state, we
> shall suspend A2DP first and then establish SCO link. Conversely, we
> shall resume A2DP link when we drop SCO link. The entire description
> can be found in the Simultaneous use of HFP, A2DP, and AVRCP Profiles
> Whitepaper on bluetooth org web site.
> (https://www.bluetooth.org/Technical/Specifications/whitepapers.htm).
> 
> My question is,  I found there is no such sink_suspend or sink_resume
> method in D-BUS API while these functions are all implemented in Bluez
> audio module. I would like to know why don't put them to D-BUS API?
> If we need to call these functions we have to expand the D-BUS API.
> 
> One more question is, is there a formal way to test SCO/A2DP
> simultaneous case? we can't find a proper headset to test it because
> those headsets are all well implemented with the simultaneous logic,
> so there is no way to enter ourselves' code that handle this logic.
> Can we test it by configurating some test tool such as PTS?

seriously, wrong mailing list. Especially since A2DP is implemented
fully in userspace ;)

Post such questions to linux-bluetooth@vger.kernel.org please.

Regards

Marcel


