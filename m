Return-Path: <linux-kernel-owner+w=401wt.eu-S1754433AbXGaW6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbXGaW6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 18:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbXGaW6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 18:58:24 -0400
Received: from ns1.suse.de ([195.135.220.2]:49431 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbXGaW6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 18:58:23 -0400
From: Andreas Schwab <schwab@suse.de>
To: Matt Mackall <mpm@selenic.com>
Cc: Dave Hansen <haveblue@us.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: /proc/$pid/pagemap troubles
References: <1185914174.18414.184.camel@localhost>
	<20070731213718.GW11115@waste.org>
X-Yow: Life is selling REVOLUTIONARY HAIR PRODUCTS!
Date: Wed, 01 Aug 2007 00:58:21 +0200
In-Reply-To: <20070731213718.GW11115@waste.org> (Matt Mackall's message of
	"Tue\, 31 Jul 2007 16\:37\:18 -0500")
Message-ID: <je4pjkqiya.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall <mpm@selenic.com> writes:

> On Tue, Jul 31, 2007 at 01:36:14PM -0700, Dave Hansen wrote:
>> Since the pagemap code has a little header on it to help describe the
>> format, I wrote a little c program to parse its output.  I get some
>> strange results.  If I do this:
>> 
>> 	fd = open("/proc/1/pagemap", O_RDONLY);
>> 	count = read(fd, &endianness, 1);
>> 
>> count will always be 4.  
>
> Known bug, fixed in my pending and not-currently-working update. It
> ought to return 0 for short reads.

That's not a good choice.  Returning 0 means EOF, but there is actually
data to be read.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
