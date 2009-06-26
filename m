Return-Path: <linux-kernel-owner+w=401wt.eu-S1756555AbZFZI2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555AbZFZI2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 04:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbZFZI16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 04:27:58 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33738 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbZFZI15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 04:27:57 -0400
Subject: Re: kmemleak suggestion (long message)
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Sergey Senozhatsky <sergey.senozhatsky@mail.by>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <1246004740.30717.3.camel@pc1117.cambridge.arm.com>
References: <20090625221816.GA3480@localdomain.by>
	 <20090626065923.GA14078@elte.hu>
	 <1246004740.30717.3.camel@pc1117.cambridge.arm.com>
Date: Fri, 26 Jun 2009 11:27:59 +0300
Message-Id: <1246004879.27533.18.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-26 at 09:25 +0100, Catalin Marinas wrote:
> BTW, this was questioned in the past as well - do we still need the
> automatic scanning from a kernel thread? Can a user cron job just read
> the kmemleak file?

I think the kernel thread makes sense so that we get an early warning in
syslog. Ingo, what's your take on this from autoqa point of view?

			Pekka

