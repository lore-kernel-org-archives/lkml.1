Return-Path: <linux-kernel-owner+w=401wt.eu-S932666AbYCEXLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932666AbYCEXLX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 18:11:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933026AbYCEXJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 18:09:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41625 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933543AbYCEXJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 18:09:07 -0500
Date: Wed, 5 Mar 2008 14:59:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: oakad@exemail.com.au
Cc: linux-kernel@vger.kernel.org, oakad@yahoo.com
Subject: Re: [PATCH 05/11] tifm: fix the MemoryStick host fifo handling code
Message-Id: <20080305145914.042b3f70.akpm@linux-foundation.org>
In-Reply-To: <1204646548-27466-6-git-send-email-oakad@exemail.com.au>
References: <1204646548-27466-1-git-send-email-oakad@exemail.com.au>
	<1204646548-27466-2-git-send-email-oakad@exemail.com.au>
	<1204646548-27466-3-git-send-email-oakad@exemail.com.au>
	<1204646548-27466-4-git-send-email-oakad@exemail.com.au>
	<1204646548-27466-5-git-send-email-oakad@exemail.com.au>
	<1204646548-27466-6-git-send-email-oakad@exemail.com.au>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  5 Mar 2008 03:02:22 +1100
oakad@exemail.com.au wrote:

> +			buf = kmap_atomic(pg, KM_BIO_SRC_IRQ) + p_off;

I am unable to convince myself that this driver always has local IRQs
disabled when altering the KM_BIO_SRC_IRQ slot.  Does it?
