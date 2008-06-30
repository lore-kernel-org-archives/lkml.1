Return-Path: <linux-kernel-owner+w=401wt.eu-S1762798AbYF3Rni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762798AbYF3Rni (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 13:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762159AbYF3Rn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 13:43:28 -0400
Received: from tetsuo.zabbo.net ([207.173.201.20]:39194 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072AbYF3Rn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 13:43:27 -0400
Message-ID: <48691B3E.5040402@oracle.com>
Date: Mon, 30 Jun 2008 10:43:26 -0700
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Nikanth Karthikesan <knikanth@suse.de>
CC: linux-aio@kvack.org, linux-kernel@vger.kernel.org,
       Benjamin LaHaise <bcrl@kvack.org>, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] aio: aio_complete() will never be called in interrupt
 context
References: <200806260930.59836.knikanth@suse.de>
In-Reply-To: <200806260930.59836.knikanth@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nikanth Karthikesan wrote:
> aio_complete() is never called from interrupt context. It is called from user 
> context or worker threads. Remove disabling interrupts and for kmap_atomic use 
> KM_USER slots instead of KM_IRQ slots.

How are you testing these patches?

- z
