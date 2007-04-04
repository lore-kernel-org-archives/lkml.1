Return-Path: <linux-kernel-owner+w=401wt.eu-S2992631AbXDDFUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992631AbXDDFUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 01:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992634AbXDDFUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 01:20:41 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47418 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992631AbXDDFUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 01:20:40 -0400
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
From: David Woodhouse <dwmw2@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Brad Boyer <flar@allandria.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <17939.10130.687893.167511@cargo.ozlabs.ibm.com>
References: <1175610345.2665.15.camel@shinybook.infradead.org>
	 <17938.57292.870224.132415@cargo.ozlabs.ibm.com>
	 <1175642916.10567.24.camel@shinybook.infradead.org>
	 <20070403212928.GA12951@cynthia.pants.nu>
	 <20070404022544.59b022a6@the-village.bc.nu>
	 <17939.10130.687893.167511@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 01:19:59 -0400
Message-Id: <1175663999.2932.8.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 (2.10.0-7.fc7.dwmw2.2) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 14:20 +1000, Paul Mackerras wrote:
> I never suggested *all* serial ports should be /dev/ttySn, I said that
> the built-in ports on the motherboard should be /dev/ttySn. 

Why? What's so special about the name 'ttyS'?
 
> The built-in ports can generally be enumerated early on boot in a
> stable order, and they should be assigned the low ttySn numbers,
> regardless of what chip is used to implement them. 

I don't see why that 'should' be the case. Certainly it _isn't_ the case
on most supported platforms -- we have separate device numbers, and
names, for most types of ports. There's only one or two drivers which
abuse ttySn for anything other than 8250 ports.

-- 
dwmw2

