Return-Path: <linux-kernel-owner+w=401wt.eu-S1755295AbYFXGjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbYFXGjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 02:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbYFXGj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 02:39:28 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:41221 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750936AbYFXGj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 02:39:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=b9SJWzj3N3uE+iaejNoSPvZFHIQ71AlPtAvhFBAaqxy9DNL131U0rtmgcmvbxo+eRIs4vgI8MdNIFOyRjjYREt6zD/DGJXIfvZ1PBSqgvINu7a1I/ntvk8aeXT8J9DHRZAf44HqUmR6bJlzlfOgqqp8AR2YJs21+aGpp1neaPXw=  ;
X-YMail-OSG: vI2B6Z0VM1lrvScf_VTYB2dVzbNI5MWkCvkVP7Fe1ZHk7PMuKawGT66tEvKVeLzf8PwxTOJEojhfOWPtBz8EL9Y.ILTJvBXIi1FkRpt3t.0nFrDkUW_3pDhLSs2TzsXyPcI-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [patch] x86 supports NO_IRQ convention
Date: Mon, 23 Jun 2008 23:39:25 -0700
User-Agent: KMail/1.9.9
Cc: benh@kernel.crashing.org, lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       hpa@zytor.com
References: <fa.mcHAIQmpGZB1Vrm7ZD4/q9eo08Y@ifi.uio.no> <fa.EDfpY1oxab2UaliWrUY0jyr5T1k@ifi.uio.no> <486059F9.6060901@shaw.ca>
In-Reply-To: <486059F9.6060901@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806232339.25926.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 June 2008, Robert Hancock wrote:
> IRQ 0 is only used by 
> architecture-specific code and is not sharable,

That seems to be the consensus, and it does reflect
how it's used on all architectures I happen to have
seen it in use.

Leaving the question then of what should happen to
the existing NO_IRQ code ... none of the declarations
seems to have a comment "deprecated, don't use this"
and most of the defined values are nonzero.

Some docs appear to be missing.
