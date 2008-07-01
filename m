Return-Path: <linux-kernel-owner+w=401wt.eu-S1757357AbYGAI0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbYGAI0A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 04:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbYGAIZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 04:25:45 -0400
Received: from mx1.suse.de ([195.135.220.2]:59685 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754031AbYGAIZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 04:25:44 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH] aio: aio_complete() will never be called in interrupt context
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: linux-aio@kvack.org, linux-kernel@vger.kernel.org,
       Benjamin LaHaise <bcrl@kvack.org>, Jeff Moyer <jmoyer@redhat.com>
References: <200806260930.59836.knikanth@suse.de> <48691B3E.5040402@oracle.com>
In-Reply-To: <48691B3E.5040402@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
Date: Tue, 1 Jul 2008 13:59:56 +0530
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200807011359.57164.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 June 2008 23:13:26 Zach Brown wrote:
> Nikanth Karthikesan wrote:
> > aio_complete() is never called from interrupt context. It is called from
> > user context or worker threads. Remove disabling interrupts and for
> > kmap_atomic use KM_USER slots instead of KM_IRQ slots.
>
> How are you testing these patches?
>

I did not do any specific testing. Just ran multiple instances of a file-copy 
utility that uses aio and a bit of Chris Mason's aio-stress.

Thanks
Nikanth karthikesan

p.s: Is the archives of the linux-aio list available somewhere? The URL in the 
mail footer seems to be unavailable.





