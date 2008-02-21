Return-Path: <linux-kernel-owner+w=401wt.eu-S932470AbYBUUcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470AbYBUUcW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 15:32:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757011AbYBUUcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 15:32:08 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:61046 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755054AbYBUUcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 15:32:07 -0500
Date: Thu, 21 Feb 2008 21:31:25 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: linux-kernel@vger.kernel.org, kernel@avr32linux.org
Subject: Re: MMC card detection
Message-ID: <20080221213125.3c2b79d9@dhcp-252-066.norway.atmel.com>
In-Reply-To: <20080221194620.6a3c0030@dhcp-252-066.norway.atmel.com>
References: <20080221194620.6a3c0030@dhcp-252-066.norway.atmel.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2008 19:46:20 +0100
Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:

> In order to fix this problem, I think I need a way to tell the MMC core
> that the card really is gone and that there's no point trying to
> communicate with it. Is there any way I can do that?

Never mind, I figured it out. I can simply fail the command right away
with -ENOMEDIUM if I know the card isn't present. Seems to work like a
charm.

Haavard
