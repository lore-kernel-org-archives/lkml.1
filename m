Return-Path: <linux-kernel-owner+w=401wt.eu-S1765109AbXFRSMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765109AbXFRSMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 14:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764525AbXFRSMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 14:12:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53618 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764688AbXFRSMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 14:12:10 -0400
Date: Mon, 18 Jun 2007 19:12:01 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Robert Hancock <hancockr@shaw.ca>
Cc: David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Mike Frysinger <vapier@gentoo.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       rmk@arm.linux.org.uk
Subject: Re: [patch] use __asm__ and __volatile__ in i386/arm/s390 byteorder.h
Message-ID: <20070618181201.GB15922@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Robert Hancock <hancockr@shaw.ca>,
	David Woodhouse <dwmw2@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Arjan van de Ven <arjan@infradead.org>,
	Mike Frysinger <vapier@gentoo.org>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
	rmk@arm.linux.org.uk
References: <fa.Xa4Tv0RVV3kUIdHC69Jp/LpQPcg@ifi.uio.no> <fa.D5W5QzyAnzzOD5Ln35+YDQKzWsE@ifi.uio.no> <fa.XhJVn2uLXM0A6yjcYTr2E44DELQ@ifi.uio.no> <fa.tGqwq8EAmSwz5rSn2D2AkvD+yt0@ifi.uio.no> <46769643.7010106@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46769643.7010106@shaw.ca>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 08:27:15AM -0600, Robert Hancock wrote:
> If we expect userspace apps to include them, then I would vote for no, 
> not for anything outside of #ifdef __KERNEL__ in exported headers. Keep 
> in mind also that C++ apps may need to include these as well and those 
> extensions don't always play well in C++ mode. (Last instance I ran into 
> was the ioctl argument checking macros _IOR, _IOW, etc. that create 
> non-compiling code if you use them in a C++ program.)

There's absolutely no reason to obfucate kernel headers for usage in
C++ source files.

