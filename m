Return-Path: <linux-kernel-owner+w=401wt.eu-S1758776AbYGAPhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbYGAPhk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 11:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755088AbYGAPhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 11:37:31 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:46944 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703AbYGAPhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 11:37:31 -0400
X-IronPort-AV: E=Sophos;i="4.27,732,1204502400"; 
   d="scan'208";a="836882"
Message-ID: <486A4F5F.7030506@eu.citrix.com>
Date: Tue, 01 Jul 2008 16:38:07 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: [PATCH 0 of 2] fbcon: blinking text fix and implementation
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Jul 2008 15:37:28.0736 (UTC) FILETIME=[5E813A00:01C8DB90]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
I have recently found out that there is a small bug in fbcon handling
the background color.
The forth bit of the background color is the blink property bit, not the
intensity bit, as for the foreground color.
Therefore it shouldn't be included in the background color.
I also wrote a very simple implementation for blinking text in fbcon,
using the flashcursor function to scan the buffer for blinking chars.
Any suggestion or critic is very welcome, but don't be too hard :)

Cheers,

Stefano Stabellini
