Return-Path: <linux-kernel-owner+w=401wt.eu-S935014AbXGLQVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935014AbXGLQVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 12:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758185AbXGLQVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 12:21:30 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:37060 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933AbXGLQV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 12:21:29 -0400
Subject: Re: [PATCH] Immunize rcu_dereference() against crazy compiler
	writers
From: Josh Triplett <josht@linux.vnet.ibm.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
       akpm@linux-foundation.org
In-Reply-To: <20070712010058.GA30869@linux.vnet.ibm.com>
References: <20070712010058.GA30869@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 12 Jul 2007 09:08:20 -0700
Message-Id: <1184256500.3000.1.camel@josh-work.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-11 at 18:00 -0700, Paul E. McKenney wrote:
> Turns out that compiler writers are a bit more aggressive about optimizing
> than one might expect.  This patch prevents a number of such optimizations
> from messing up rcu_deference().  This is not merely a theoretical
> problem, as evidenced by the rmb() in mce_log().
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Josh Triplett <josh@kernel.org>

- Josh Triplett


