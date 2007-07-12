Return-Path: <linux-kernel-owner+w=401wt.eu-S1763931AbXGLMHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763931AbXGLMHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 08:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753603AbXGLMHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 08:07:04 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:40333 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156AbXGLMHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 08:07:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=fAg6/xbDOv2Ss606ONwUbAVC10NWROzVxKNjriBThmi6XjMTB9r49mdktylpuodVOfL9MslsqM/lMMclYXfBlUWGhAIujoaAkU+FG/oIOyTQ5pO0g+1VXbUufq7YkFAGlaXLk3M7rFZ7A13q8QVXdVpKYaAk5vXYQkbtgSSmU/M=
Message-ID: <367a23780707120506o423f6352h5edeca8535135068@mail.gmail.com>
Date: Thu, 12 Jul 2007 14:06:54 +0200
From: "Kacper Wysocki" <kacperw@online.no>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [ck] Re: -mm merge plans for 2.6.23
Cc: "Matthew Hawkins" <darthmdh@gmail.com>, linux-kernel@vger.kernel.org,
       "Con Kolivas" <kernel@kolivas.org>, "ck list" <ck@vds.kolivas.org>,
       linux-mm@kvack.org, "Paul Jackson" <pj@sgi.com>
In-Reply-To: <20070710181419.6d1b2f7e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <200707102015.44004.kernel@kolivas.org>
	 <b21f8390707101802o2d546477n2a18c1c3547c3d7a@mail.gmail.com>
	 <20070710181419.6d1b2f7e.akpm@linux-foundation.org>
X-Google-Sender-Auth: 2ac1a9897ab4ed2c
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/11/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 11 Jul 2007 11:02:56 +1000 "Matthew Hawkins" <darthmdh@gmail.com> wrote:
>
> > We all know swap prefetch has been tested out the wazoo since Moses was a
> > little boy, is compile-time and runtime selectable, and gives an important
> > and quantifiable performance increase to desktop systems.
>
> Always interested.  Please provide us more details on your usage and
> testing of that code.  Amount of memory, workload, observed results,
> etc?

Swap prefetch has been around for years, and it's a complete boon for
the desktop user and a noop in any other situation. In addition to the
sp_tester tool which consistently shows a definite advantage, there
are many user reports that show the noticeable improvements it has.
The many people who have tried it out have generally chosen to switch
to patched kernels because of the performance increase.

It's been discussed on the lkml many times before, we've been over
performance, testing and impact. The big question is: why *don't* we
merge it?

-Kacper
