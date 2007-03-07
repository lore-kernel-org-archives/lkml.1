Return-Path: <linux-kernel-owner+w=401wt.eu-S1161266AbXCGEPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161266AbXCGEPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 23:15:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161272AbXCGEPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 23:15:31 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161266AbXCGEPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 23:15:30 -0500
Date: Tue, 6 Mar 2007 23:02:48 -0500
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andres Salomon <dilinger@debian.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: don't use ZONE_DMA unless CONFIG_ZONE_DMA is set in setup.c
Message-ID: <20070307040248.GA30278@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andres Salomon <dilinger@debian.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
References: <45EDFEDB.3000507@debian.org> <20070306175246.b1253ec3.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306175246.b1253ec3.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2007 at 05:52:46PM -0800, Andrew Morton wrote:
 > On Tue, 06 Mar 2007 18:52:59 -0500
 > Andres Salomon <dilinger@debian.org> wrote:
 > 
 > > If CONFIG_ZONE_DMA is ever undefined, ZONE_DMA will also not be defined,
 > > and setup.c won't compile.  This wraps it with an #ifdef.
 > > 
 > 
 > I guess if anyone tries to disable ZONE_DMA on i386 they'll pretty quickly
 > discover that.  But I don't think we need to "fix" it yet?

CONFIG_ZONE_DMA isn't even optional on i386, so I'm curious how
you could hit this compile failure.

	Dave

-- 
http://www.codemonkey.org.uk
