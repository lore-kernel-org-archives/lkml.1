Return-Path: <linux-kernel-owner+w=401wt.eu-S1756076AbXKEMYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbXKEMYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 07:24:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754368AbXKEMXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 07:23:52 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:39534 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbXKEMXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 07:23:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=lBot3A2pc0pogJ0wM+6BzdN4oLsWJg5UGxmKds6viMCbNd9TdiGteHrb4y0rO8hXNrtTrSo8G422mwsJ0RvgvWEFGESrl7UcMOVTK0z37dY3l7xMZx7i28xvY6B4HiF6GFVjHYe1tAh1vAJcS312Txxw/VvJnYej7X7QiRjEtb0=
Message-ID: <84144f020711050423r7a1f0e55g36c8c5ad29bfc700@mail.gmail.com>
Date: Mon, 5 Nov 2007 14:23:50 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: RFC: Reproducible oops with lockdep on count_matching_names()
Cc: "Michael Buesch" <mb@bu3sch.de>, "Luis R. Rodriguez" <mcgrof@gmail.com>,
       "Michael Wu" <flamingice@sourmilk.net>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       "Ingo Molnar" <mingo@redhat.com>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       linux-kernel@vger.kernel.org, "Michael Chan" <mchan@broadcom.com>,
       netdev@vger.kernel.org, "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <1194264016.27652.428.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071101191716.GA3201@pogo> <1194001120.27652.353.camel@twins>
	 <43e72e890711031258g4ccd9cd0hc4520e9473f6ce49@mail.gmail.com>
	 <200711032106.56569.mb@bu3sch.de> <1194264016.27652.428.camel@twins>
X-Google-Sender-Auth: f052747249068b3a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Sat, 2007-11-03 at 21:06 +0100, Michael Buesch wrote:
> Who is responsible for slab btw?
> I mean, someone should be interested in getting this bug fixed. :)
> When using slab I see random corruptions. I think related to rmmod, but
> I'm not sure. I don't see this with slub.

Is CONFIG_DEBUG_SLAB enabled? Usually these kind of random corruptions
are caused by someone passing a bad pointer to kfree() or
kmem_cache_free().

                                  Pekka
