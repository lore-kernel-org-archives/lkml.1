Return-Path: <linux-kernel-owner+w=401wt.eu-S1754316AbZCKEQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbZCKEQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 00:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177AbZCKEQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 00:16:41 -0400
Received: from gate.crashing.org ([63.228.1.57]:54525 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753412AbZCKEQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 00:16:39 -0400
Subject: Re: [PATCH 6/7] powerpc: Hook up rtc-generic, and kill rtc-ppc
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       linux-m68k@vger.kernel.org,
       Alessandro Zummo <alessandro.zummo@towertech.it>,
       rtc-linux@googlegroups.com, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
       linuxppc-dev@ozlabs.org, Paul Mundt <lethal@linux-sh.org>,
       Dann Frazier <dannf@dannf.org>
In-Reply-To: <1236607181.572.180.camel@macbook.infradead.org>
References: <1236605183-22718-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <1236605183-22718-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <1236605183-22718-3-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <1236605183-22718-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <1236605183-22718-5-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <1236605183-22718-6-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <1236605183-22718-7-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <1236607181.572.180.camel@macbook.infradead.org>
Content-Type: text/plain
Date: Wed, 11 Mar 2009 15:15:23 +1100
Message-Id: <1236744923.7086.41.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-09 at 13:59 +0000, David Woodhouse wrote:
> On Mon, 2009-03-09 at 14:26 +0100, Geert Uytterhoeven wrote:
> > PowerPC has been a long time user of the generic RTC abstraction, so hook up
> > rtc-generic:
> >   - Create the "rtc-generic" platform device if ppc_md.get_rtc_time is set,
> >   - Kill rtc-ppc, as rtc-generic offers the same functionality in a more
> >     generic way, and supports autoloading through udev.
> > 
> > Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> 
> Acked-By: David Woodhouse <David.Woodhouse@intel.com>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>


