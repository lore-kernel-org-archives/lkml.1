Return-Path: <linux-kernel-owner+w=401wt.eu-S1761523AbYD2Q3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761523AbYD2Q3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 12:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758147AbYD2Q3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 12:29:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:64736 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757621AbYD2Q3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 12:29:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dL1kxe4ofLRndWprTf+GXqIRfGhoa0IQxyiHNC7lh2Lt1hnNkXXfrUci8Fn0P6kVhIIEbqZPFMLIaDQPaOBHkjp9TXfsIv3vBcbvIltuKHK1A40pVhPMY6l5eEQF7LmFE3YkbICYo1q0PXYhMK5DZgFkw4ogdxHhR0e4vJmwSvA=
Message-ID: <e2e108260804290929l3c7a6a07nddc18512abb9e6ed@mail.gmail.com>
Date: Tue, 29 Apr 2008 18:29:01 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/8] lockdep: fix recursive read lock validation
Cc: ego@in.ibm.com, linux-kernel@vger.kernel.org,
       "Zdenek Kabelac" <zdenek.kabelac@gmail.com>,
       "Oleg Nesterov" <oleg@tv-sign.ru>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Srivatsa Vaddagiri" <vatsa@in.ibm.com>
In-Reply-To: <1209485739.13978.96.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080429125659.GA23562@in.ibm.com>
	 <20080429125750.GB23562@in.ibm.com>
	 <e2e108260804290616l489ac8c2udcb2e80fc268b72b@mail.gmail.com>
	 <1209481050.13978.72.camel@twins>
	 <e2e108260804290803u75764b56t1c475a6d186aca8d@mail.gmail.com>
	 <1209482101.13978.91.camel@twins>
	 <e2e108260804290903x44ad1cb7x1278027ab51b0831@mail.gmail.com>
	 <1209485739.13978.96.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 6:15 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
>  > Or: whether or not to allow a sequence like "rlock(a); rlock(b);
>  > runlock(b); runlock(a); rlock(b); rlock(a);" is something we can
>  > choose. We do not have to forbid this sequence -- we can choose
>  > whether or not we allow this sequence.
>
>  I'm utterly confused now; I never argued that it would get deadlocks;
>  and I said I choose to not allow it from a lockdep pov. What else do you
>  want?

So we both agree that the statement in the original e-mail (by Gautham
R Shenoy) is wrong ? The original e-mail stated that obtaining reader
locks in an inconsistent order is wrong.

Bart.
