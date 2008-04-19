Return-Path: <linux-kernel-owner+w=401wt.eu-S1762204AbYDSSLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762204AbYDSSLM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 14:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755343AbYDSSK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 14:10:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38074 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbYDSSK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 14:10:58 -0400
Date: Sat, 19 Apr 2008 11:10:38 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: mingo@elte.hu, airlied@linux.ie,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Make CONFIG_ARP=m under x86_64
Message-ID: <20080419111038.34d0dfbd@laptopd505.fenrus.org>
In-Reply-To: <alpine.LNX.1.10.0804182304040.26385@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0804182304040.26385@fbirervta.pbzchgretzou.qr>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008 23:21:44 +0200 (CEST)
Jan Engelhardt <jengelh@computergmbh.de> wrote:

> 
> The way it is written, CONFIG_AGP is always y for x86_64 - not so
> nice when you want to use nvagp instead which requries agpgart to be 
> unloadable.

where's the source code for nvagp? what does it do that normal agp does not do?
Also.. running without agp on x86-64 (heck on x86) tends to be rather unpleasant wrt resource allocations..

So I don't think this patch is a good idea at all..

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
