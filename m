Return-Path: <linux-kernel-owner+w=401wt.eu-S1758314AbYJMP4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758314AbYJMP4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 11:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755703AbYJMP40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 11:56:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56523 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755562AbYJMP4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 11:56:25 -0400
Date: Mon, 13 Oct 2008 08:53:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Madhusudhan Chikkature" <madhu.cr@ti.com>
Cc: gadiyar@ti.com, johnpol@2ka.mipt.ru, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org
Subject: Re: [PATCH 1/5] HDQ Driver for OMAP2430/3430
Message-Id: <20081013085323.f8bd7efb.akpm@linux-foundation.org>
In-Reply-To: <062801c92d37$3413bdd0$LocalHost@wipultra1303>
References: <5A47E75E594F054BAF48C5E4FC4B92AB02D6107AF0@dbde02.ent.ti.com>
	<20081010133845.8b82fac3.akpm@linux-foundation.org>
	<062801c92d37$3413bdd0$LocalHost@wipultra1303>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 13 Oct 2008 18:55:43 +0530 "Madhusudhan Chikkature" <madhu.cr@ti.com> wrote:
> 
> ----- Original Message ----- 
> From: "Andrew Morton" <akpm@linux-foundation.org>
> To: "Gadiyar, Anand" <gadiyar@ti.com>
> Cc: <johnpol@2ka.mipt.ru>; <linux-kernel@vger.kernel.org>; <linux-omap@vger.kernel.org>; <madhu.cr@ti.com>
> Sent: Saturday, October 11, 2008 2:08 AM
> Subject: Re: [PATCH 1/5] HDQ Driver for OMAP2430/3430
> 
> 
> >> +       /* set the GO bit */
> >> +       hdq_reg_merge(hdq_data, OMAP_HDQ_CTRL_STATUS, OMAP_HDQ_CTRL_STATUS_GO,
> >> +               OMAP_HDQ_CTRL_STATUS_DIR | OMAP_HDQ_CTRL_STATUS_GO);
> >> +       /* wait for the TXCOMPLETE bit */
> >> +       ret = wait_event_interruptible_timeout(hdq_wait_queue,
> >> +               hdq_data->hdq_irqstatus, OMAP_HDQ_TIMEOUT);
> >> +       if (ret < 0) {
> >> +               dev_dbg(hdq_data->dev, "wait interrupted");
> >> +               return -EINTR;
> >> +       }
> > 
> > Is this desirable?  The user hits ^C and the driver bails out?
> > 
> > I assume so, but was this tested?
> 
> Andrew, What is the test scenario you mean here? A user hitting ^C when the driver is waiting for the TXCOMPLETE bit?

Yes.


