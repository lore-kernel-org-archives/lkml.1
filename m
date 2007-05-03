Return-Path: <linux-kernel-owner+w=401wt.eu-S1767138AbXEBXFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767138AbXEBXFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 19:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767195AbXEBXFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 19:05:48 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:55387
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767138AbXEBXFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 19:05:47 -0400
Message-ID: <46392750.8080600@microgate.com>
Date: Wed, 02 May 2007 18:05:36 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] synclink_gt add compat_ioctl
References: <1178137281.10111.8.camel@amdx2.microgate.com> <200705030009.11502.arnd@arndb.de> <46392142.2030201@microgate.com> <200705030047.56286.arnd@arndb.de>
In-Reply-To: <200705030047.56286.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> The same function contains a copy_from_user(), which cannot
> be called with interrupts disabled, so yes, I am very certain
> it will not change.

Good point.

--
Paul
