Return-Path: <linux-kernel-owner+w=401wt.eu-S1755019AbZIJDXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbZIJDXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 23:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbZIJDX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 23:23:29 -0400
Received: from relay1.sgi.com ([192.48.179.29]:38914 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753441AbZIJDX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 23:23:29 -0400
Date: Wed, 9 Sep 2009 22:23:30 -0500
From: Jack Steiner <steiner@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Chris Friesen <cfriesen@nortel.com>, Daniel Walker <dwalker@fifo99.com>,
       mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] x86: SGU UV Add volatile semantics to macros that access chipset registers
Message-ID: <20090910032330.GA10878@sgi.com>
References: <20090909154246.GA26716@sgi.com> <1252512600.14793.125.camel@desktop> <20090909180110.GA10311@sgi.com> <1252519885.14793.135.camel@desktop> <4AA7F9E5.4070506@nortel.com> <20090909193829.GB10530@sgi.com> <4AA84BE7.9010304@zytor.com> <20090910022226.GB10038@sgi.com> <4AA86CFA.8090000@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA86CFA.8090000@zytor.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 09, 2009 at 08:05:30PM -0700, H. Peter Anvin wrote:
> On 09/09/2009 07:22 PM, Jack Steiner wrote:
> > Add volatile-semantics to the SGI UV read/write macros that are
> > used to access chipset memory mapped registers. No direct
> > references to volatile are made. Instead the readq/writeq
> > macros are used.
> > 
> > Signed-off-by: Jack Steiner <steiner@sgi.com>
> 
> The -q part of readq/writeq is qword, 64 bits.  It looks like you're
> replacing references of other sizes with qword references; was that
> intended?

No, it was not. Most macros are quad-word but I see one that should have been
"char".

Thanks for catching that.  New patch in the morning.

--- jack
