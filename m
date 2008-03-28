Return-Path: <linux-kernel-owner+w=401wt.eu-S1754406AbYC1Nkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406AbYC1Nkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 09:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbYC1Nks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 09:40:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46743 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbYC1Nkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 09:40:47 -0400
Date: Fri, 28 Mar 2008 14:44:13 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Paul Jackson <pj@sgi.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, ying.huang@intel.com, hpa@zytor.com,
       andi@firstfloor.org, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] x86_64 boot -v2: Add linked listof struct setup_data to boot protocol
Message-ID: <20080328134413.GT29105@one.firstfloor.org>
References: <1206672578.13404.21.camel@caritas-dev.intel.com> <86802c440803272233ved9c1d6w44f8722c85cf4c62@mail.gmail.com> <20080328083613.f058172f.pj@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080328083613.f058172f.pj@sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 08:36:13AM -0500, Paul Jackson wrote:
> YH wrote:
> > interesting, that 512nodes/4096 box physics memory is not continuous?
> 
> If each node board is stuffed with the same amount of RAM,
> and that amount of RAM is a power of two size, then you

There are likely per node memory holes too, right?

So even in that scenario it would be not continuous.

-Andi
