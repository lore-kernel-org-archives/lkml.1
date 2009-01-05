Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbZAEWea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbZAEWea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 17:34:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbZAEWeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 17:34:22 -0500
Received: from eazy.amigager.de ([213.239.192.238]:35787 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbZAEWeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 17:34:21 -0500
Date: Mon, 5 Jan 2009 23:34:14 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: No suspend to RAM possible with 2.6.28
Message-ID: <20090105223414.GA24056@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20090105221949.GA2443@x61>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090105221949.GA2443@x61>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 23:19:50 +0100, Tino Keitel wrote:
> Hi,
> 
> on my ThinkPad X61s, I can not use suspend to RAM anymore. It works
> with 2.6.27.
> 
> This is what happens:
> 
> $ cat /sys/power/state 
> mem disk
> $ echo mem > /sys/power/state
> bash: echo: write error: Device or resource busy
> $

It seems like TuxOnIce was the culprit. Without this patch, suspend to
RAM works. Sorry for the noise.

Regards,
Tino
