Return-Path: <linux-kernel-owner+w=401wt.eu-S1756530AbYAUAA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530AbYAUAA5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 19:00:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754517AbYAUAAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 19:00:49 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:25895 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404AbYAUAAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 19:00:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=li+ZhaiVk1jxbs2DKAd1yUkDE/xOjfeRDR8eOYV5BfCuL/qowXQlhhOt8md6Oty7OIcJYzFBh4B5irjIwvwjcM2Pnx3QgkBTUc2S2B5p5TE2d991qIcrdTQqdnOZD36V3TXxzLQGZt1Vb/Iul28TXU5Zi9ksB6Yq+/X8YXc5d0g=
Message-ID: <86802c440801201600p36493ads56d8e2654526d84b@mail.gmail.com>
Date: Sun, 20 Jan 2008 16:00:46 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86_64: update e820 instead of updating end_pfn
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Andi Kleen" <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080120092027.GB8379@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801192045.17291.yinghai.lu@sun.com>
	 <4792DE0C.9060906@zytor.com> <200801200017.24445.yinghai.lu@sun.com>
	 <20080120092027.GB8379@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 20, 2008 1:20 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
>
> > [PATCH] x86_64: update e820 instead of updating end_pfn
> >
> > when mtrr is not covering all e820 table, need to trim the ram, need
> > to update e820
>
> ok, i like this approach even more - applied. Would you like to have a
> shot at adding mtrr_trim_uncached_memory() to 32-bit too? It is affected
> by the same problem (if not more).

for 32 bit, it could use the same mtrr_trim_uncached_memory.

but we need to move mtrr_bp_init calling into setup_arch.

YH

YH
