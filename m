Return-Path: <linux-kernel-owner+w=401wt.eu-S1759398AbZEZW0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759398AbZEZW0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 18:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759224AbZEZWZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 18:25:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:44069 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759361AbZEZWZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 18:25:04 -0400
Subject: Re: [PATCH] devres: WARN() and return, don't crash on device_del()
 of uninitialized device
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com,
       Kay Sievers <kay.sievers@vrfy.org>, Tejun Heo <tj@kernel.org>
In-Reply-To: <20090526141552.507f8821.akpm@linux-foundation.org>
References: <20090525065346.1D991DE2AC@ozlabs.org>
	 <20090526141552.507f8821.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 27 May 2009 08:23:30 +1000
Message-Id: <1243376610.17847.12.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-26 at 14:15 -0700, Andrew Morton wrote:
> 
> This could be coded a little more neatly as:
> 
>         /* Looks like an uninitialized device structure */
>         if (WARN_ON(dev->devres_head.next == NULL))
>                 return -ENODEV;

Oh I didn't know we could do that nowadays...

Cheers,
Ben.


