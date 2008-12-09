Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051AbYLILYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbYLILYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 06:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbYLILYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 06:24:11 -0500
Received: from senator.holtmann.net ([87.106.208.187]:56169 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbYLILYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 06:24:10 -0500
Subject: Re: [PATCH] Bluetooth node manager causes up to ~3.25s delay in
 freezing tasks.
From: Marcel Holtmann <marcel@holtmann.org>
To: Nigel Cunningham <ncunningham@crca.org.au>
Cc: linux-bluetooth@vger.kernel.org,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1228809311.6681.12.camel@nigel-laptop>
References: <1228809311.6681.12.camel@nigel-laptop>
Content-Type: text/plain
Date: Tue, 09 Dec 2008 12:24:03 +0100
Message-Id: <1228821843.19553.3.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nigel,

> The bluetooth nodemanager function "nodemgr_host_thread" contains a loop
> that calls try_to_freeze near the top of the loop, but then delays for
> up to 3.25 seconds (plus time to do work) before getting back to the top
> of the loop. When starting a cycle post-boot, this doesn't seem to bite,
> but it is causing a noticeable delay at boot time, when freezing
> processes prior to starting to read the image.

I don't wanna disappoint you, but IEEE1394 is actually Firewire and not
Bluetooth :)

Regards

Marcel


