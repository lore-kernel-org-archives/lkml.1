Return-Path: <linux-kernel-owner+w=401wt.eu-S1760565AbXJEJTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760565AbXJEJTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 05:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755062AbXJEJTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 05:19:30 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:38849 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434AbXJEJT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 05:19:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=YHcJP5ui944jwgGjQrBcRFSha4fJkBAeR655iln6YmmHXjORwfU1Ha2NO8QYUrOHBgecIe49gGoe2AhyMeOLJi3oecrVWBVaSgAcuerpoHRkUmjbuRJYRYPGfWV8g/0R9OWs8bU1QaDs6HFyydxs01I+VpKu2WdKyi3oIIC4Dx0=
Message-ID: <84144f020710050219k2460631cjfd556d6eae645887@mail.gmail.com>
Date: Fri, 5 Oct 2007 12:19:28 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Jens Axboe" <jens.axboe@oracle.com>
Subject: Re: SLUB performance regression vs SLAB
Cc: "David Chinner" <dgc@sgi.com>, "David Miller" <davem@davemloft.net>,
       cebbert@redhat.com, willy@linux.intel.com, clameter@sgi.com,
       nickpiggin@yahoo.com.au, hch@lst.de, mel@skynet.ie,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com
In-Reply-To: <20071005064853.GI5711@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <470554D9.2050505@redhat.com>
	 <20071004.141113.08322956.davem@davemloft.net>
	 <47055F84.109@redhat.com>
	 <20071004.150718.95506800.davem@davemloft.net>
	 <20071004222356.GH23367404@sgi.com> <20071005064853.GI5711@kernel.dk>
X-Google-Sender-Auth: fda9d7c1f2c49342
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/5/07, Jens Axboe <jens.axboe@oracle.com> wrote:
> I'd like to second Davids emails here, this is a serious problem. Having
> a reproducible test case lowers the barrier for getting the problem
> fixed by orders of magnitude. It's the difference between the problem
> getting fixed in a day or two and it potentially lingering for months,
> because email ping-pong takes forever and "the test team has moved on to
> other tests, we'll let you know the results of test foo in 3 weeks time
> when we have a new slot on the box" just removing any developer
> motivation to work on the issue.

What I don't understand is that why don't the people who _have_ access
to the test case fix the problem? Unlike slab, slub is not a pile of
crap that only Christoph can hack on...

                                   Pekka
