Return-Path: <linux-kernel-owner+w=401wt.eu-S1758618AbYBKQbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618AbYBKQbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 11:31:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758193AbYBKQaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 11:30:55 -0500
Received: from waste.org ([66.93.16.53]:42578 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755513AbYBKQaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 11:30:52 -0500
Subject: Re: [PATCH] [RESENDING] netconsole: register cmdline netconsole
	configs to configfs
From: Matt Mackall <mpm@selenic.com>
To: Joonwoo Park <joonwpark81@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, satyam@infradead.org
In-Reply-To: <12027209202884-git-send-email-joonwpark81@gmail.com>
References: <12027209122955-git-send-email-joonwpark81@gmail.com>
	 <12027209163465-git-send-email-joonwpark81@gmail.com>
	 <12027209202884-git-send-email-joonwpark81@gmail.com>
Content-Type: text/plain
Date: Mon, 11 Feb 2008 10:30:13 -0600
Message-Id: <1202747413.28085.1.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-02-11 at 18:08 +0900, Joonwoo Park wrote:
> This patch intorduces cmdline netconsole configs to register to
> configfs
> with dynamic netconsole. Satyam Sharma who designed shiny dynamic
> reconfiguration for netconsole, mentioned about this issue already.
> (http://lkml.org/lkml/2007/7/29/360)
> But I think, without separately managing of two kind of netconsole
> target
> objects, it's possible by using config_group instead of
> config_item in the netconsole_target and default_groups feature of
> configfs.
> 
> Patch was tested with configuration creation/destruction by kernel and
> module.
> And it makes possible to enable/disable, modify and review netconsole
> target configs from cmdline.

I'm afraid I'm going to have to leave review of this to someone who is
clueful about configfs. But it seems reasonable.

-- 
Mathematics is the supreme nostalgia of our time.

