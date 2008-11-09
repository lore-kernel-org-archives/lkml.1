Return-Path: <linux-kernel-owner+w=401wt.eu-S1755579AbYKIOU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbYKIOU2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 09:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754892AbYKIOUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 09:20:18 -0500
Received: from cpsmtpo-eml03.KPNXCHANGE.COM ([213.75.38.152]:34743 "EHLO
	cpsmtpo-eml03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754842AbYKIOUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 09:20:17 -0500
From: Frans Pop <elendil@planet.nl>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Subject: Re: Bootup time regression from 2.6.27 to 2.6.28-rc3+
Date: Sun, 9 Nov 2008 15:20:12 +0100
User-Agent: KMail/1.9.9
Cc: arjan@infradead.org, rjw@sisk.pl, linux-kernel@vger.kernel.org
References: <20081104173300.GF6134@ics.muni.cz> <200811090106.04579.rjw@sisk.pl> <20081108205532.7952fec6@infradead.org> <20081108205532.7952fec6@infradead.org> <20081109085649.GD4353@ics.muni.cz>
In-reply-To: <20081109085649.GD4353@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811091520.13044.elendil@planet.nl>
X-OriginalArrivalTime: 09 Nov 2008 14:20:13.0898 (UTC) FILETIME=[480A52A0:01C94276]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lukas Hejtmanek wrote:
> Moreover, I discovered that I have to hit a keyboard several times
> during the boot to boot up.
> 
> The delay depends on keyboard hit. If I do not touch the keyboard, it
> waits forever.. Looks like something needs an interrupt..

That sounds very much like the issues described in this thread:
http://lkml.org/lkml/2008/10/28/226

Do you use LUKS encryption and/or LVM?

Cheers,
FJP
