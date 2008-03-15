Return-Path: <linux-kernel-owner+w=401wt.eu-S1752812AbYCOExT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbYCOExT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 00:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751108AbYCOExM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 00:53:12 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:54140 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbYCOExL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 00:53:11 -0400
Date: Sat, 15 Mar 2008 05:52:28 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: john stultz <johnstul@us.ibm.com>
cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 4/5]  ntp.c code flow clenaups  (from Ingo)
In-Reply-To: <1205554366.6122.88.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0803150551020.1791@scrub.home>
References: <1205553852.6122.76.camel@localhost.localdomain> 
 <1205553938.6122.79.camel@localhost.localdomain>  <1205554018.6122.81.camel@localhost.localdomain>
  <1205554210.6122.85.camel@localhost.localdomain> <1205554366.6122.88.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 14 Mar 2008, john stultz wrote:

> +static inline void process_adjtimex_adj_offset(struct timex *txc, long sec)

Somewhat ugly name...
>From an userspace perspective it's the core of ntp_adjtime(), so I'd 
prefer something close to that.

bye, Roman
