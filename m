Return-Path: <linux-kernel-owner+w=401wt.eu-S1760448AbXF0H5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760448AbXF0H5s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 03:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754066AbXF0H5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 03:57:42 -0400
Received: from canuck.infradead.org ([209.217.80.40]:54372 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbXF0H5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 03:57:41 -0400
Subject: Re: [PATCH] Export usb_gadgetfs.h to userspace
From: David Woodhouse <dwmw2@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>
In-Reply-To: <20070627003538.f15bef21.akpm@linux-foundation.org>
References: <11827637791662-git-send-email-hskinnemoen@atmel.com>
	 <20070627003538.f15bef21.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 27 Jun 2007 08:57:23 +0100
Message-Id: <1182931043.6409.8.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-27 at 00:35 -0700, Andrew Morton wrote:
> make[2]: *** No rule to make target
> `/usr/src/devel/include/linux/usb_gadgetfs.h', needed by
> `/usr/src/devel/usr/include/linux/usb_gadgetfs.h'.  Stop. 

i.e. "Cannot export file to ./usr/include/linux/ because it doesn't
exist in ./include/linux/ in the first place" -- for the reasons Håvard
pointed out.

-- 
dwmw2

