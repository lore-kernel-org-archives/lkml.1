Return-Path: <linux-kernel-owner+w=401wt.eu-S1759237AbZABTd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237AbZABTd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 14:33:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932188AbZABTdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 14:33:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41032 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169AbZABTdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 14:33:41 -0500
Message-ID: <495E6BEE.1000805@zytor.com>
Date: Fri, 02 Jan 2009 11:33:02 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Sam Ravnborg <sam@ravnborg.org>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3]: Replace kernel/timeconst.pl with kernel/timeconst.sh
References: <200901020207.30359.rob@landley.net> <200901020213.30658.rob@landley.net> <20090102090439.GA3057@uranus.ravnborg.org> <200901020600.47847.rob@landley.net>
In-Reply-To: <200901020600.47847.rob@landley.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley wrote:
> 
> You mean "The new shell script is much simpler, about 1/4 the size, runs on 
> Red Hat 9 from 2003, and isn't perl?" :)
> 

And introduces unclear environment dependencies depending on how
external utilities are implemented.

The whole point of why that script was written in Perl was to have
access to arbitrary-precision arithmetic -- after it was shown that bc
would simply lock up on some systems.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

