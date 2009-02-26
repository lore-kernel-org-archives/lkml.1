Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbZBZSyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbZBZSyj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 13:54:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbZBZSya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 13:54:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:53768 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbZBZSy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 13:54:29 -0500
Subject: Re: [PATCH] x86: enable DMAR by default
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kyle McMartin <kyle@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090226180304.GA10940@elte.hu>
References: <20090226175756.GP6690@bombadil.infradead.org>
	 <20090226180304.GA10940@elte.hu>
Content-Type: text/plain
Date: Fri, 27 Feb 2009 03:54:00 +0900
Message-Id: <1235674440.8730.119.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-26 at 19:03 +0100, Ingo Molnar wrote:
> * Kyle McMartin <kyle@infradead.org> wrote:
> 
> > From: Kyle McMartin <kyle@redhat.com>
> > 
> > Now that the obvious bugs have been worked out, specifically 
> > the iwlagn issue, and the write buffer errata, DMAR should be 
> > safe to turn back on by default. (We've had it on since those 
> > patches were first written a few weeks ago, without any 
> > noticeable bug reports (most have been due to the dma-api 
> > debug patchset.))
> > 
> > Signed-off-by: Kyle McMartin <kyle@redhat.com>
> > 
> > ---
> > Probably 2.6.29 material, but should definitely go in for 2.6.30.
> 
> Definitely agreed on .30. Can do it in .29 as well if David and 
> the rest of the Cc: agrees.

Definitely. I wasn't any happier than you were with the patch which
disabled it in the first place.... but it was necessary at the time.

Enthusiastically-Acked-by: David Woodhouse <David.Woodhouse@intel.com>

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

