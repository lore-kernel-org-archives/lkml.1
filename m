Return-Path: <linux-kernel-owner+w=401wt.eu-S1760808AbZDQNcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760808AbZDQNcU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 09:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754298AbZDQNcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 09:32:06 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54507 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754041AbZDQNcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 09:32:04 -0400
Date: Fri, 17 Apr 2009 14:32:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Paul Fulghum <paulkf@microgate.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] synclink_gt add receive pio mode
Message-ID: <20090417143236.015a2d5b@lxorguk.ukuu.org.uk>
In-Reply-To: <1239897204.13866.7.camel@x2.microgate.com>
References: <1239897204.13866.7.camel@x2.microgate.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Apr 2009 10:53:24 -0500
Paul Fulghum <paulkf@microgate.com> wrote:

> Add receive programmed IO mode to reduce receive latency
> when using low data rates. The receive FIFO trigger
> level of 128 bytes used in DMA mode creates excessive latency
> when operating at low data rates. PIO mode is selected when user
> application requests data in blocks of less than 128 bytes.
> 

Looks good but needs a Signed-off-by 

Alan
