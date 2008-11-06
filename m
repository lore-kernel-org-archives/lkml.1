Return-Path: <linux-kernel-owner+w=401wt.eu-S1753892AbYKFDp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbYKFDp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 22:45:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbYKFDpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 22:45:18 -0500
Received: from ozlabs.org ([203.10.76.45]:43867 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629AbYKFDpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 22:45:18 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: virtio: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Thu, 6 Nov 2008 14:45:11 +1100
User-Agent: KMail/1.9.10
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
References: <1225393822.21973.39.camel@nga.site>
In-Reply-To: <1225393822.21973.39.camel@nga.site>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811061445.12050.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 October 2008 06:10:22 Kay Sievers wrote:
> This patch is part of a larger patch series which will remove
> the "char bus_id[20]" name string from struct device. The device
> name is managed in the kobject anyway, and without any size
> limitation, and just needlessly copied into "struct device".

OK, I've applied this patch.

I'm curious how you're going to handle out-of-memory conditions?

Thanks,
Rusty.
