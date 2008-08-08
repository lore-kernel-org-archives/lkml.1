Return-Path: <linux-kernel-owner+w=401wt.eu-S1761866AbYHHWRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761866AbYHHWRs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbYHHWRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 18:17:40 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:48343 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbYHHWRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 18:17:39 -0400
Subject: Re: [RFC][PATCH 1/4] checkpoint-restart: general infrastructure
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: containers@lists.linux-foundation.org, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <489CB3CA.6050304@cs.columbia.edu>
References: <20080807224033.FFB3A2C1@kernel>
	 <20080807224034.735B1F84@kernel> <200808081146.54834.arnd@arndb.de>
	 <1218221451.19082.36.camel@nimitz>  <489CB3CA.6050304@cs.columbia.edu>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 15:17:35 -0700
Message-Id: <1218233855.19082.52.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-08 at 16:59 -0400, Oren Laadan wrote:
> To avoid repetitive malloc/free, ctx->hbuf is a buffer to host headers
> as they are read;

kmalloc/kfree() area really, really fast.  I wonder if the code gets
easier or harder to read if we just alloc/free as we need to.

How large are these allocations, usually?  Will stack allocation work in
most cases?

-- Dave

