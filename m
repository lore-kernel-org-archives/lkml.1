Return-Path: <linux-kernel-owner+w=401wt.eu-S932995AbYEUJ7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995AbYEUJ7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 05:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756147AbYEUJ7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 05:59:41 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38891 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756600AbYEUJ7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 05:59:40 -0400
Date: Wed, 21 May 2008 10:46:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Li Yang <leoli@freescale.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Kong Wei <weikong@redflag-linux.com>
Subject: Re: [PATCH] [mm] limit the min_free_kbytes
Message-ID: <20080521104643.3c7165ce@core>
In-Reply-To: <1211362481-2136-1-git-send-email-leoli@freescale.com>
References: <1211362481-2136-1-git-send-email-leoli@freescale.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008 17:34:41 +0800
Li Yang <leoli@freescale.com> wrote:

> From: Kong Wei <weikong@redflag-linux.com>
> 
> Unlimited of min_free_kbytes is dangerous,
> An user of our company set this value bigger than 3584*1024*K,
> cause the system OOM on DMA.

You need to be root to set this value, and as root you could equally just
type "halt", run a real time process in a tight loop or reformat the hard
disk.

NAK this patch

