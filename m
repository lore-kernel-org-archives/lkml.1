Return-Path: <linux-kernel-owner+w=401wt.eu-S1758406AbXL3Xfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758406AbXL3Xfn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 18:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755082AbXL3Xff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 18:35:35 -0500
Received: from [194.117.236.238] ([194.117.236.238]:41939 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754490AbXL3Xff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 18:35:35 -0500
Date: Mon, 31 Dec 2007 01:32:34 +0200
From: Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Richard Harman <richard@richardharman.com>
Cc: pharon@gmail.com, Rene Herman <rene.herman@keyaccess.nl>,
       "David P. Reed" <dpreed@reed.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] Option to disable AMD C1E (allows dynticks to work)
Message-ID: <20071231013234.66e5c021@linux360.ro>
In-Reply-To: <47779EDA.8070408@richardharman.com>
References: <47765D11.2040903@reed.com>
	<1198967334.5049.3.camel@iamer-laptop>
	<4776F6A0.9010801@keyaccess.nl>
	<1198979361.11150.2.camel@iamer-laptop>
	<20071230121725.11d05099@linux360.ro>
	<47780657.8020208@richardharman.com>
	<20071230231818.54877db8@linux360.ro>
	<47779EDA.8070408@richardharman.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Dec 2007 08:36:26 -0500
Richard Harman <richard@richardharman.com> wrote:

> The C1E patch, which permits the lapic to function *does* make my
> system stable.  My previous method of testing (using USB peripherals)
> and checking /proc/interrupts for ERRor interrupts so far hasn't
> caused the system to lock up.

Let me put it another way: have you actually experienced any lockups
with a vanilla (that is, with no patches applied) 2.6.24-rc6 kernel?
Try first with "force_amd_c1e". So far, all I see is that you're
getting nohz/dynticks working with my patch, and that's okay, it's the
expected behavior. But I seriously doubt that it's my patch that keeps
your system from locking up. I'm not bugging you just to clarify this
matter, but if your system locked up iff (as in both necessary and
sufficient) the patch was _not_ applied, that would be a really serious
issue.
