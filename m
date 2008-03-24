Return-Path: <linux-kernel-owner+w=401wt.eu-S1756170AbYCXQ0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbYCXQ0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 12:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751AbYCXQ0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 12:26:04 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:47904 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbYCXQ0E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 12:26:04 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: nitingupta910@gmail.com
Subject: Re: [PATCH 2/6] compcache: block device - internal defs
Date: Mon, 24 Mar 2008 17:25:59 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <200803242033.30782.nitingupta910@gmail.com>
In-Reply-To: <200803242033.30782.nitingupta910@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803241725.59726.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nitin,

>  +#define K(x)   ((x) >> 10)
>  +#define KB(x)  ((x) << 10)

Hm. These look cryptic unless you remember what they do.
Could have better names?

> +#define CC_DEBUG2((fmt,arg...) \
> +       printk(KERN_DEBUG C fmt,##arg)

Unbalanced parenthesis.

Just my 0.05zl.

	Mariusz
