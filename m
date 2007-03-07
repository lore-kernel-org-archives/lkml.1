Return-Path: <linux-kernel-owner+w=401wt.eu-S1161205AbXCGBww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161205AbXCGBww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 20:52:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161206AbXCGBww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 20:52:52 -0500
Received: from smtp.osdl.org ([65.172.181.24]:42768 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161205AbXCGBwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 20:52:51 -0500
Date: Tue, 6 Mar 2007 17:52:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andres Salomon <dilinger@debian.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: don't use ZONE_DMA unless CONFIG_ZONE_DMA is set in
 setup.c
Message-Id: <20070306175246.b1253ec3.akpm@linux-foundation.org>
In-Reply-To: <45EDFEDB.3000507@debian.org>
References: <45EDFEDB.3000507@debian.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Mar 2007 18:52:59 -0500
Andres Salomon <dilinger@debian.org> wrote:

> If CONFIG_ZONE_DMA is ever undefined, ZONE_DMA will also not be defined,
> and setup.c won't compile.  This wraps it with an #ifdef.
> 

I guess if anyone tries to disable ZONE_DMA on i386 they'll pretty quickly
discover that.  But I don't think we need to "fix" it yet?

