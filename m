Return-Path: <linux-kernel-owner+w=401wt.eu-S1762943AbYCVClo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762943AbYCVClo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 22:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758657AbYCVCk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 22:40:26 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:17908 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761285AbYCVCkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 22:40:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rYgVQE6Y6Nw0vydcHEnLR2Xxs8+2djCU+vCzda//Lee0oCFF04bQ0YxkclyW0s1yMlDWctzs0YfW/8n9+RnlqJW8JCISLMKua9eL4Qt36P9w6TA9afbGcNJXHodyaT5Y7BjxjosxVQBIDQVAXpXoFCAQDMaK6QYufXiapYlXDrA=
Message-ID: <8bd0f97a0803211940s6d7b5214q57f4f9eabd11a991@mail.gmail.com>
Date: Fri, 21 Mar 2008 22:40:23 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [2/2] vmallocinfo: Add caller information
Cc: "Christoph Lameter" <clameter@sgi.com>, akpm@linux-foundation.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080321205559.GC3509@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080318222701.788442216@sgi.com>
	 <20080318222827.519656153@sgi.com> <20080319214227.GA4454@elte.hu>
	 <Pine.LNX.4.64.0803191659410.4645@schroedinger.engr.sgi.com>
	 <20080321110008.GW20420@elte.hu>
	 <Pine.LNX.4.64.0803211034140.18671@schroedinger.engr.sgi.com>
	 <20080321184526.GB6571@elte.hu>
	 <Pine.LNX.4.64.0803211212520.19558@schroedinger.engr.sgi.com>
	 <20080321205559.GC3509@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 4:55 PM, Ingo Molnar <mingo@elte.hu> wrote:
>  * Christoph Lameter <clameter@sgi.com> wrote:
>  > > the best i found for lockdep was to include a fair number of them,
>  > > and to skip the top 3. struct vm_area that vmalloc uses isnt
>  > > space-critical, so 4-8 entries with a 3 skip would be quite ok. (but
>  > > can be more than that as well)
>  >
>  > STACKTRACE depends on STACKTRACE_SUPPORT which is not available on all
>  > arches? alpha blackfin ia64 etc are missing it?
>
>  one more reason for them to implement it.

as long as the new code in question is properly ifdef-ed, making it
rely on STACKTRACE sounds fine.  i'll open an item in our Blackfin
tracker to add support for it.
-mike
