Return-Path: <linux-kernel-owner+w=401wt.eu-S1754804AbYJJGDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbYJJGDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 02:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYJJGD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 02:03:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:49942 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbYJJGDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 02:03:25 -0400
Subject: Re: cgroup task groups appears sensitive to absolute magnitude of
	shares
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <48EE8D06.9060503@nortel.com>
References: <48EE8D06.9060503@nortel.com>
Content-Type: text/plain
Date: Fri, 10 Oct 2008 08:03:13 +0200
Message-Id: <1223618594.7382.60.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-09 at 17:00 -0600, Chris Friesen wrote:

> Going to 4000/2000/1000/200 doesn't seem to give noticeable 
> improvements, and going to 40000/20000/10000/2000 causes the test to 
> behave unpredictably, either taking abnormally long to complete or else 
> not completing at all.

Hmm, I would have expected it to work for at least the normal nice range
of weight values..

Will have to look into that I suppose..

