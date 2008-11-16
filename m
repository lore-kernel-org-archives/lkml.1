Return-Path: <linux-kernel-owner+w=401wt.eu-S1753348AbYKPMjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbYKPMjV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 07:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbYKPMjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 07:39:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42110 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873AbYKPMjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 07:39:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alexey Starikovskiy <aystarik@gmail.com>,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: ACPI: EC: GPE storm detected, transactions will use polling mode
Date: Sun, 16 Nov 2008 13:44:07 +0100
User-Agent: KMail/1.9.9
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>
References: <1226722577.3104.4.camel@LiNuX> <1226817681.3133.7.camel@LiNuX> <491FECAE.6050005@gmail.com>
In-Reply-To: <491FECAE.6050005@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811161344.07872.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 16 of November 2008, Alexey Starikovskiy wrote:
> Justin P. Mattock wrote:
> > Well; reverting:
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=06cf7d3c7af902939cd1754abcafb2464060cba8
> > is keeping the system from having a gpe storm
> > (for at least four hours now);
> > haven't had a chance to drain the battery and see
> > the affects from that scenario.
> >
> >   
> Justin, by decreasing threshold, we just change how often _detection_ of 
> the storm fires, not the storm itself.

Yes, I think what happens is that we just detect the interrupt storm with the
lower threshold, so the storm occured anyway previously, but it went unnoticed
(not necessarily a good thing).

There is nothing to worry about as long as the box works as expected.

Thanks,
Rafael
