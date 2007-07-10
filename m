Return-Path: <linux-kernel-owner+w=401wt.eu-S1764889AbXGJJeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764889AbXGJJeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 05:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764676AbXGJJbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 05:31:44 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:28837 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764683AbXGJJbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 05:31:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=cVbWSEYVgW3Me9D2Vnjc1YFxW4J687edVYmRR0gS1qLUuFCWRyp0oG1UrNE+Wfg2O7sdoEErpDnth0MgIOykfwphgsyDkbRZDYDEkQaBT35008r/IzjWaPp0+EFSeshpK+VWSqyM8V4aRzIrGCbOCzpXzZ7faPhxjlsYfCUa0uo=
Message-ID: <84144f020707100231p5013e1aer767562c26fc52eeb@mail.gmail.com>
Date: Tue, 10 Jul 2007 12:31:40 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
Cc: "Christoph Lameter" <clameter@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, suresh.b.siddha@intel.com, corey.d.gough@intel.com,
       "Matt Mackall" <mpm@selenic.com>,
       "Denis Vlasenko" <vda.linux@googlemail.com>,
       "Erik Andersen" <andersen@codepoet.org>
In-Reply-To: <469342DC.8070007@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070708034952.022985379@sgi.com>
	 <20070708035018.074510057@sgi.com> <20070708075119.GA16631@elte.hu>
	 <20070708110224.9cd9df5b.akpm@linux-foundation.org>
	 <4691A415.6040208@yahoo.com.au>
	 <84144f020707090404l657a62c7x89d7d06b3dd6c34b@mail.gmail.com>
	 <Pine.LNX.4.64.0707090907010.13970@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0707101049230.23040@sbz-30.cs.Helsinki.FI>
	 <469342DC.8070007@yahoo.com.au>
X-Google-Sender-Auth: 3144849cfd22a4ff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

Pekka J Enberg wrote:
> > That's 92 KB advantage for SLUB with debugging enabled and 240 KB when
> > debugging is disabled.

On 7/10/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> Interesting. What kernel version are you using?

Linus' git head from yesterday so the results are likely to be
sensitive to workload and mine doesn't represent real embedded use.
