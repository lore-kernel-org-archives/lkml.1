Return-Path: <linux-kernel-owner+w=401wt.eu-S1755932AbZADBgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbZADBgW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 20:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbZADBgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 20:36:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44978 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbZADBgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 20:36:09 -0500
Message-ID: <49601279.8070603@zytor.com>
Date: Sat, 03 Jan 2009 17:35:53 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Sam Ravnborg <sam@ravnborg.org>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3]: Replace kernel/timeconst.pl with kernel/timeconst.sh
References: <200901020207.30359.rob@landley.net> <200901020600.47847.rob@landley.net> <495E6BEE.1000805@zytor.com> <200901031932.51873.rob@landley.net>
In-Reply-To: <200901031932.51873.rob@landley.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley wrote:
> 
> I consider this a step up from code with an implicit dependency on a CPAN 
> library.
> 

There is no CPAN library in use.  Math::BigInt is a standard part of
Perl, and the canned values is there only to support extremely old
versions of Perl, or weird system configurations, as a
belt-and-suspenders measure.

	-hpa
