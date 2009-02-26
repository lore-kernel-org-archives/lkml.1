Return-Path: <linux-kernel-owner+w=401wt.eu-S1756888AbZBZV1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888AbZBZV1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 16:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbZBZV1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 16:27:04 -0500
Received: from mx2.redhat.com ([66.187.237.31]:32831 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222AbZBZV1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 16:27:03 -0500
To: sidc7 <siddhartha.chhabra@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Copy on write and page initialization
References: <22175803.post@talk.nabble.com>
	<200902242017.46605.nickpiggin@yahoo.com.au>
	<22178976.post@talk.nabble.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Thu, 26 Feb 2009 16:26:54 -0500
In-Reply-To: <22178976.post@talk.nabble.com> (siddhartha.chhabra@gmail.com's message of "Tue, 24 Feb 2009 01:47:02 -0800 (PST)")
Message-ID: <y0meixkopnl.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sidc7 <siddhartha.chhabra@gmail.com> writes:

> I figured why it was not breaking, cow_user_page is inlined hence it wont
> break there [...]

There is good chance a systemtap can find it for you despite inlining:

# stap -e 'probe kernel.function("cow_user_page") { print_backtrace() }'


- FChE
