Return-Path: <linux-kernel-owner+w=401wt.eu-S934472AbXHHQdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934472AbXHHQdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 12:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758040AbXHHQc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 12:32:57 -0400
Received: from smtp.nokia.com ([131.228.20.172]:28891 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759780AbXHHQc4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 12:32:56 -0400
Subject: Re: LogFS take five
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070808161234.GB15319@lazybastard.org>
References: <20070808161234.GB15319@lazybastard.org>
Content-Type: text/plain; charset=utf-8
Date: Wed, 08 Aug 2007 19:27:17 +0300
Message-Id: <1186590437.19606.38.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 08 Aug 2007 16:27:17.0790 (UTC) FILETIME=[FCA0ABE0:01C7D9D8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jörn,

On Wed, 2007-08-08 at 18:12 +0200, Jörn Engel wrote:
> It has been a while, mainly because I found a bunch of races and didn't
> want to publish anything before those were fixed.  Patch is still
> against 2.6.21 and just for review.

I'm very interested how do you account free/dirty space in LogFS:

* When you need to write new data, how do you select the place where to
write?
* When you run out of space, how do select find the segment to
garbage-collect?

For any given segment (or eraseblock), how do you find amount of free
and dirty space in it?

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

