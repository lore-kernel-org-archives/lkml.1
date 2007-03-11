Return-Path: <linux-kernel-owner+w=401wt.eu-S932778AbXCKDUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932778AbXCKDUj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 22:20:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932805AbXCKDUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 22:20:39 -0500
Received: from ozlabs.org ([203.10.76.45]:36831 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932778AbXCKDUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 22:20:38 -0500
Subject: Re: [PATCH] Use more gcc extensions in the Linux headers
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
In-Reply-To: <Pine.LNX.4.61.0703110353330.16857@yvahk01.tjqt.qr>
References: <1173419792.32234.131.camel@localhost.localdomain>
	 <1173481052.32234.137.camel@localhost.localdomain>
	 <Pine.LNX.4.61.0703100156490.8799@yvahk01.tjqt.qr>
	 <1173581437.32234.168.camel@localhost.localdomain>
	 <Pine.LNX.4.61.0703110353330.16857@yvahk01.tjqt.qr>
Content-Type: text/plain
Date: Sun, 11 Mar 2007 14:19:36 +1100
Message-Id: <1173583177.32234.186.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-03-11 at 03:58 +0100, Jan Engelhardt wrote:
> >-#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
> >+#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
> >+
> 80 cols *cough* :)

I think your cough added a column?

Rusty.


