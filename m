Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164AbXI0Jki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbXI0Jki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 05:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753029AbXI0Jka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 05:40:30 -0400
Received: from styx.suse.cz ([82.119.242.94]:41846 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753320AbXI0Jka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 05:40:30 -0400
Date: Thu, 27 Sep 2007 11:40:19 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid: hidraw_connect memleak fix
In-Reply-To: <200709270933.13497.m.kozlowski@tuxland.pl>
Message-ID: <Pine.LNX.4.64.0709271139380.7567@jikos.suse.cz>
References: <200709270933.13497.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2007, Mariusz Kozlowski wrote:

> It looks like hidraw_connect() is leaking memory in case of failure. 
> Also it should return -ENOMEM when kzalloc fails.

Mariusz,

good catch, will apply to me tree.

Thanks,

-- 
Jiri Kosina
SUSE Labs
