Return-Path: <linux-kernel-owner+w=401wt.eu-S1760837AbXFDTCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760837AbXFDTCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 15:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758728AbXFDTCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 15:02:42 -0400
Received: from gw.goop.org ([64.81.55.164]:48739 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758685AbXFDTCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 15:02:41 -0400
Message-ID: <466461C4.2050806@goop.org>
Date: Mon, 04 Jun 2007 12:02:28 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Jeff Garzik <jeff@garzik.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Al Viro <viro@ftp.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org, Chen Li-jun <cljun@xiyou.edu.cn>,
       Wang Ya-gang <lazy_linux@126.com>
Subject: Re: [RFC] Documentation/CodingStyle: Add rules for goto labels (-v2)
References: <20070603142450.GA4230@localhost.localdomain> <20070603142939.GW4095@ftp.linux.org.uk> <20070603074552.430c3d02.rdunlap@xenotime.net> <4662DFCF.3010606@garzik.org> <20070604045857.GE2161@localhost.localdomain> <4663B84E.2060103@goop.org> <20070604081938.GC2074@localhost.localdomain> <20070604183014.GB16187@uranus.ravnborg.org>
In-Reply-To: <20070604183014.GB16187@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> If local(__label__) really so widely used in the kernel that it deserves
> a place in coding-style?
> A quick grep did not say so.
>   

Probably not, and its use shouldn't be (even tacitly) encouraged.  It's
only really useful for defining a local label within a macro, and
there's probably something wrong with your macro if you need a local label.

    J
