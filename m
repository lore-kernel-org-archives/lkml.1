Return-Path: <linux-kernel-owner+w=401wt.eu-S1758087AbZADUkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087AbZADUkd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 15:40:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbZADUkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 15:40:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40388 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbZADUkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 15:40:22 -0500
Message-ID: <49611E88.6010204@zytor.com>
Date: Sun, 04 Jan 2009 12:39:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Sam Ravnborg <sam@ravnborg.org>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3]: Replace kernel/timeconst.pl with kernel/timeconst.sh
References: <200901020207.30359.rob@landley.net> <200901031932.51873.rob@landley.net> <20090104120735.72840fdb@lxorguk.ukuu.org.uk> <200901041303.12687.rob@landley.net>
In-Reply-To: <200901041303.12687.rob@landley.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley wrote:
> 
> C) The only calculation which can overflow 64 bits (the ADJ32 one) turns out 
> not to need arbitrary precision math, just 72 bits, and if it ever uses more 
> than 32 then bottom 32 are all zero before the divide so you can do it in 
> three lines.
> 

... for the current code (32 bits).  When we get an overflow-less 64-bit
implementation, this code will have to be redone, which is not true for
a properly done implementation.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

