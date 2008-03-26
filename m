Return-Path: <linux-kernel-owner+w=401wt.eu-S1759556AbYCZAjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759556AbYCZAjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 20:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756265AbYCZAjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 20:39:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55961
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754649AbYCZAjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 20:39:32 -0400
Date: Tue, 25 Mar 2008 17:39:28 -0700 (PDT)
Message-Id: <20080325.173928.67585726.davem@davemloft.net>
To: dmosberger@gmail.com
Cc: peterc@gelato.unsw.edu.au, clameter@sgi.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       torvalds@linux-foundation.org, ianw@gelato.unsw.edu.au
Subject: Re: larger default page sizes...
From: David Miller <davem@davemloft.net>
In-Reply-To: <ed5aea430803251734u70f199w10951bc4f0db6262@mail.gmail.com>
References: <20080325.162244.61337214.davem@davemloft.net>
	<87tziu5q37.wl%peter@chubb.wattle.id.au>
	<ed5aea430803251734u70f199w10951bc4f0db6262@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David Mosberger-Tang" <dmosberger@gmail.com>
Date: Tue, 25 Mar 2008 18:34:13 -0600

> Why not just repeat the PTEs for super-pages?

This is basically how we implement hugepages in the page
tables on sparc64.
