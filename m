Return-Path: <linux-kernel-owner+w=401wt.eu-S1758874AbYFDIq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874AbYFDIq2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 04:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbYFDIqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 04:46:20 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:32991 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444AbYFDIqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 04:46:19 -0400
Date: Wed, 4 Jun 2008 10:46:32 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH -mm] clean up duplicated alloc/free_thread_info
Message-ID: <20080604104632.45299954@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20080604080242P.fujita.tomonori@lab.ntt.co.jp>
References: <20080603140620S.fujita.tomonori@lab.ntt.co.jp>
	<20080603123112.0d58e193@hskinnemo-gx745.norway.atmel.com>
	<20080604080242P.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Jun 2008 08:46:01.0416 (UTC) FILETIME=[6A8FE480:01C8C61F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> I can just remove the duplicated defines on avr32 since avr32 has
> THREAD_SIZE_ORDER define and uses __get_free_pages/free_pages.

Yeah, that should do it. Thanks!

Haavard
