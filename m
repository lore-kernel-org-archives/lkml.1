Return-Path: <linux-kernel-owner+w=401wt.eu-S1761539AbXGKKSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761539AbXGKKSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 06:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758386AbXGKKSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 06:18:18 -0400
Received: from ozlabs.org ([203.10.76.45]:60416 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757899AbXGKKSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 06:18:18 -0400
Subject: Re: [PATCH RFC] try_module_get usage
From: Rusty Russell <rusty@rustcorp.com.au>
To: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
Cc: dedekind@infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <1184140531.4608.16.camel@sebastian.kern.oss.ntt.co.jp>
References: <1184140531.4608.16.camel@sebastian.kern.oss.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Date: Wed, 11 Jul 2007 20:18:01 +1000
Message-Id: <1184149081.6005.606.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-11 at 16:55 +0900, Fernando Luis Vázquez Cao wrote:
> I keep seeing uses of try_module_get(THIS_MODULE) which seem to mimic
> the behavior of the former MOD_INC_USE_COUNT. The UBI driver is one
> example:
> 
> int ubi_get_device_info(int ubi_num, struct ubi_device_info *di)
> {
>         const struct ubi_device *ubi;
> 
>         if (!try_module_get(THIS_MODULE))
>                 return -ENODEV;

Yes, this code is wrong.

Thanks,
Rusty.

