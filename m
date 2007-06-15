Return-Path: <linux-kernel-owner+w=401wt.eu-S1756771AbXFOSHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbXFOSHi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 14:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbXFOSHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 14:07:30 -0400
Received: from smtp-out.google.com ([216.239.45.13]:34300 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbXFOSH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 14:07:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=BXFRyUZoTgvpYjPnVzPJN8jTFr7m9CKisT/cGP2yNwzG8uwJJ4tJu0eYHK/MwZWCb
	4kDndPd9zsXwEQozbWyRg==
Message-ID: <65dd6fd50706151107v784a252aw89a128f255304ef6@mail.gmail.com>
Date: Fri, 15 Jun 2007 11:07:15 -0700
From: "Ollie Wild" <aaw@google.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [patch 0/3] no MAX_ARG_PAGES -v2
Cc: "Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
       parisc-linux@lists.parisc-linux.org, linux-mm@kvack.org,
       linux-arch@vger.kernel.org, "Andrew Morton" <akpm@osdl.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <ak@suse.de>
In-Reply-To: <1181899478.7348.349.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070613100334.635756997@chello.nl>
	 <617E1C2C70743745A92448908E030B2A01AF860A@scsmsx411.amr.corp.intel.com>
	 <65dd6fd50706132323i9c760f4m6e23687914d0c46e@mail.gmail.com>
	 <1181810319.7348.345.camel@twins>
	 <65dd6fd50706141358i39bba32aq139766c8a1a3de2b@mail.gmail.com>
	 <1181899478.7348.349.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/15/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Thu, 2007-06-14 at 13:58 -0700, Ollie Wild wrote:
>
> >   A good heuristic, though, might be to limit
> > argument size to a percentage (say 25%) of maximum stack size and
> > validate this inside copy_strings().
>
> This seems to do:

Looks good.

Ollie
