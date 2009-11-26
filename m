Return-Path: <linux-kernel-owner+w=401wt.eu-S1752742AbZKZLjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbZKZLjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 06:39:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbZKZLjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 06:39:06 -0500
Received: from waste.org ([173.11.57.241]:56052 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbZKZLjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 06:39:05 -0500
Subject: Re:
From: Matt Mackall <mpm@selenic.com>
To: Ian Molton <ian.molton@collabora.co.uk>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, jeff@garzik.org
In-Reply-To: <1259232570-11918-1-git-send-email-ian.molton@collabora.co.uk>
References: <1259197403.2858.88.camel@calx>
	 <1259232570-11918-1-git-send-email-ian.molton@collabora.co.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Nov 2009 05:38:45 -0600
Message-ID: <1259235525.9212.444.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-26 at 10:49 +0000, Ian Molton wrote:
> Hi guys,
> 
> 	This version uses a statically allocated buffer. I dont feel it is a
> good idea not to pass the address and length of the buffer to the hardware
> drivers, as they shouldnt have intimate knowledge of the core, IMO.

I agree, but let me quote myself:
---
> +             if (!data_avail) {
> +                     bytes_read = rng_get_data(current_rng, rng_buffer,
> +                             RNG_BUFFSIZE, !(filp->f_flags & O_NONBLOCK));

No need to pass rng_buffer to the helper as there's only one with global
scope.
---

-- 
http://selenic.com : development and support for Mercurial and Linux


