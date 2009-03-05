Return-Path: <linux-kernel-owner+w=401wt.eu-S1756271AbZCEW2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271AbZCEW2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 17:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbZCEW2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 17:28:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752252AbZCEW2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 17:28:05 -0500
Date: Thu, 5 Mar 2009 14:27:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: unsik Kim <donari75@gmail.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       shdl@zakalwe.fi, harvey.harrison@gmail.com, minchan.kim@gmail.com
Subject: Re: [PATCH] mflash: Initial support
Message-Id: <20090305142746.a2c6f415.akpm@linux-foundation.org>
In-Reply-To: <57afda040903050124h30bff6fflb9d8dedde966d18c@mail.gmail.com>
References: <1235554274-794-1-git-send-email-donari75@gmail.com>
	<20090226133509.27b58014.akpm@linux-foundation.org>
	<57afda040903050124h30bff6fflb9d8dedde966d18c@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Mar 2009 18:24:47 +0900
unsik Kim <donari75@gmail.com> wrote:

> 1. ATA layer deals standard ATA protocol. ATA layer have many low-
> level device specific interface, but data transfer keeps ATA rule. But,
> mflash IO mode doesn't.
> 
> 2. Even though currently not used in mflash driver code, mflash has
> some custom command and modes. (nand fusing, firmware patch,
> etc) If this feature supported in linux kernel, ATA layer more altered.
> 
> 3. Currently PATA platform device driver doesn't support interrupt.
> (I'm not sure) But, mflash uses interrupt (polling mode is just for debug).
> 
> 4. mflash is somewhat under-develop product. Even though some
> company already using mflash their own product, I think more time is
> needed for standardization of custom command and mode. That time
> (maybe October) I will talk to with ATA people. If they accept integration,
> I will integrate.

Thsi is fairly important information.  Please include it in the changelog
for the patch, and maintain it.
