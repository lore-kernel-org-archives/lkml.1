Return-Path: <linux-kernel-owner+w=401wt.eu-S1750757AbXCHCST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750757AbXCHCST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 21:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbXCHCST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 21:18:19 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:42227 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbXCHCST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 21:18:19 -0500
From: Roman Zippel <zippel@linux-m68k.org>
To: Christoph Hellwig <hch@infradead.org>, David Brown <dmlb2000@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: PAGE_SIZE Availability Inconsistency
Date: Thu, 8 Mar 2007 03:18:04 +0100
User-Agent: KMail/1.9.5
References: <9c21eeae0703051555x1884fd7cse7968a71ec04eb27@mail.gmail.com> <20070306092917.GA5226@infradead.org>
In-Reply-To: <20070306092917.GA5226@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703080318.04631.zippel@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 06 March 2007 10:29, Christoph Hellwig wrote:

> PAGE_SIZE should not be available at all.  Please use getpagesize()
> instead.

While I agree, NBPG is a bit of a problem, although it's only needed for aout 
coredumps AFAICT, but still needed to compile e.g. gdb.

bye, Roman
