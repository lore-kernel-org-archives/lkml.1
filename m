Return-Path: <linux-kernel-owner+w=401wt.eu-S1756681AbXLTUH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbXLTUH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 15:07:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbXLTUHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 15:07:47 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43685 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752907AbXLTUHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 15:07:46 -0500
Date: Thu, 20 Dec 2007 12:06:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: Geoff Levand <geoffrey.levand@am.sony.com>, matthias.kaehlcke@gmail.com,
       linux-kernel@vger.kernel.org, linux@bohmer.net, linuxppc-dev@ozlabs.org,
       mingo@elte.hu, kjwinchester@gmail.com
Subject: Re: [PATCH 1/3] ps3: vuart: fix error path locking
Message-Id: <20071220120635.d66550bd.akpm@linux-foundation.org>
In-Reply-To: <1198179145.10713.9.camel@imap.mvista.com>
References: <20071213003028.676998182@mvista.com>
	<4760922C.2060908@am.sony.com>
	<20071218171050.5bf220fa.akpm@linux-foundation.org>
	<47688A5A.1090902@am.sony.com>
	<1198179145.10713.9.camel@imap.mvista.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2007 11:32:25 -0800 Daniel Walker <dwalker@mvista.com> wrote:

> On Tue, 2007-12-18 at 19:04 -0800, Geoff Levand wrote:
> 
> > Unfortunately there wasn't enough context in the patch to see
> > that there is a down() earlier in the routine, and that the patch
> > does indeed remove an incorrectly placed down().  Here is the
> > entire routine, marked with what the patch removes.
> > 
> 
> Andrew have you had a chance to review this?
> 

Confused.  I did review it: http://lkml.org/lkml/2007/12/18/384
