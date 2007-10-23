Return-Path: <linux-kernel-owner+w=401wt.eu-S1753727AbXJWGQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbXJWGQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 02:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751579AbXJWGQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 02:16:47 -0400
Received: from smtp-out.google.com ([216.239.33.17]:15559 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbXJWGQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 02:16:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Pkj7nGX7lUAc1Th5POefr2M7S+n16jO4sfX9i7AK2Nu9d/XTm6baTjxF4FK/e1Ken
	BFknzIrtdss300Mazoc7g==
Message-ID: <6599ad830710222316i353a25a7ha3d7f179da8cb3c7@mail.gmail.com>
Date: Mon, 22 Oct 2007 23:16:33 -0700
From: "Paul Menage" <menage@google.com>
To: vatsa@linux.vnet.ibm.com
Subject: Re: [PATCH 1/2] CFS CGroup: Code cleanup
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Srivatsa Vaddagiri" <vatsa@in.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20071023024654.GD3324@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <471D4510.9030200@google.com>
	 <20071023024654.GD3324@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/07, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:
>
> Minor nit: From pov of making this patch series git bisect safe, shouldn't we
> be registering a write_uint() handler in this patch as well?
>

Yes, we should. Sigh. I originally had the cleanup and the new
reporting interface in the same patch, and decided to split them apart
into a cleanup patch and a new feature patch, but clearly goofed. I'll
resend tomorrow with the write_uint registration in the right place.

Paul
