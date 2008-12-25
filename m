Return-Path: <linux-kernel-owner+w=401wt.eu-S1752041AbYLYNHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbYLYNHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 08:07:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750912AbYLYNHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 08:07:20 -0500
Received: from ozlabs.org ([203.10.76.45]:60452 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbYLYNHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 08:07:19 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [patch 0/2] stop_machine: create kstop threads only when needed
Date: Thu, 25 Dec 2008 23:37:11 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20081222113629.080104676@de.ibm.com>
In-Reply-To: <20081222113629.080104676@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812252337.11562.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 December 2008 22:06:29 Heiko Carstens wrote:
> Introduce stop_machine_create/destroy. With this interface subsystems
> that need a non-failing stop_machine environment can create the
> stop_machine threads before actually calling stop_machine.
> When the threads aren't needed anymore they can be killed with
> stop_machine_destroy again.

Thanks, this is straightforward and effective.

I've applied both patches,
Rusty.
