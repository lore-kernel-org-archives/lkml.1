Return-Path: <linux-kernel-owner+w=401wt.eu-S1752655AbXJWHmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbXJWHmu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 03:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbXJWHmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 03:42:42 -0400
Received: from smtp-out.google.com ([216.239.33.17]:19221 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbXJWHmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 03:42:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Ku5NGeknZUsOupEZs6wkxDWeC/PfEiG48990FfxmvXEYAxcn6OmkGYTWIyfqu6QwB
	hl+BC7ExanKZFMOnRq2qA==
Message-ID: <6599ad830710230042j1732149bw4cb8a4632a8c77bf@mail.gmail.com>
Date: Tue, 23 Oct 2007 00:42:33 -0700
From: "Paul Menage" <menage@google.com>
To: vatsa@linux.vnet.ibm.com
Subject: Re: [PATCH 1/2] CFS CGroup: Code cleanup
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Srivatsa Vaddagiri" <vatsa@in.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <6599ad830710222316i353a25a7ha3d7f179da8cb3c7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <471D4510.9030200@google.com>
	 <20071023024654.GD3324@linux.vnet.ibm.com>
	 <6599ad830710222316i353a25a7ha3d7f179da8cb3c7@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/07, Paul Menage <menage@google.com> wrote:
> On 10/22/07, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:
> >
> > Minor nit: From pov of making this patch series git bisect safe, shouldn't we
> > be registering a write_uint() handler in this patch as well?
> >
>
> Yes, we should. Sigh. I originally had the cleanup and the new
> reporting interface in the same patch, and decided to split them apart
> into a cleanup patch and a new feature patch, but clearly goofed. I'll
> resend tomorrow with the write_uint registration in the right place.

OK, this wasn't a patch goof - the original patch in my tree does have
the addition of write_uint in the cftype definition. I guess the last
hunk got lost as I transferred it to the email.

Paul
