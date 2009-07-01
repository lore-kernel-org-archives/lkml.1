Return-Path: <linux-kernel-owner+w=401wt.eu-S1757935AbZGAFyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935AbZGAFyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 01:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbZGAFyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 01:54:16 -0400
Received: from plexity.net ([206.123.115.38]:33345 "EHLO plexity.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbZGAFyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 01:54:15 -0400
Date: Tue, 30 Jun 2009 22:51:52 -0700
From: Deepak Saxena <dsaxena@plexity.net>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <HaraldWelte@viatech.com>
Subject: Re: CONFIG_VMSPLIT_3G_OPT=y && viafb && newer GCC == hang
Message-ID: <20090701055152.GA5366@plexity.net>
Reply-To: dsaxena@plexity.net
References: <20090701053747.GA5066@plexity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701053747.GA5066@plexity.net>
Organization: Plexity, LLC
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 30 2009, at 22:37, Deepak Saxena was caught saying:
> 
> During bring up of the OLPC XO-1.5 board, I am seeing an issue where if I
> enable CONFIG_VMSPLIT_3G_OPT (board has 1GiB RAM) and build a kernel with 
> gcc 4.2.4 on Ubuntu 8.0.4 or gcc 4.4 on F11, the kernel hangs on a call to 
> acquire_console_sem() from the viafbdev driver during device probe. If I
> use gcc 4.1.2 on FC6, everything works OK.

This is on 2.6.30 with some OLPC patches:

http://dev.laptop.org/git/olpc-2.6/log/?h=xo-1.5

-- 
In the end, they will not say, "those were dark times,"  they will ask
"why were their poets silent?" - Bertold Brecht

