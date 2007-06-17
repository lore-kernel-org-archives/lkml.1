Return-Path: <linux-kernel-owner+w=401wt.eu-S1761387AbXFQWyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761387AbXFQWyR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 18:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757704AbXFQWyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 18:54:06 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44068 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756155AbXFQWyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 18:54:05 -0400
Subject: Re: [patch] use __asm__ and __volatile__ in i386/arm/s390
	byteorder.h
From: Arjan van de Ven <arjan@infradead.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, rmk@arm.linux.org.uk
In-Reply-To: <200706171833.29046.vapier@gentoo.org>
References: <200706171833.29046.vapier@gentoo.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Sun, 17 Jun 2007 15:51:13 -0700
Message-Id: <1182120674.22999.4.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-06-17 at 18:33 -0400, Mike Frysinger wrote:
> This changes asm() to __asm__() and volatile to __volatile__ so that these
> headers can be used with gcc's -std=c99.

hmm but the kernel doesn't use -std=c99...


