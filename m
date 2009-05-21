Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbZEUR7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbZEUR7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 13:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbZEUR7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 13:59:33 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:43996 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbZEUR7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 13:59:33 -0400
To: Tony Lindgren <tony@atomide.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UART regs: add OMAP wakeup-enable register
References: <1242925798-29672-1-git-send-email-khilman@deeprootsystems.com>
	<20090521174620.GN8308@atomide.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Thu, 21 May 2009 10:59:31 -0700
In-Reply-To: <20090521174620.GN8308@atomide.com> (Tony Lindgren's message of "Thu\, 21 May 2009 10\:46\:20 -0700")
Message-ID: <873aaycp6k.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Lindgren <tony@atomide.com> writes:

> * Kevin Hilman <khilman@deeprootsystems.com> [090521 10:10]:
>> Add the wakeup enable register to the list of OMAP-specific UART
>> registers.  This is to support forthcoming OMAP PM enhancements which
>> use the wakeup feature of the OMAP's 8250-based UART.
>> 
>> Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
>> ---
>> The MAINTAINERS file lists the 8250 driver as orphaned, and posts to
>> linux-serial go unanswered.  How should this go upstream?
>
> I suggest you merge this into your omap PM queue and we'll merge it
> with that.

OK, I can do that but assumed it would need a serial maintainer
signoff first.

Kevin
