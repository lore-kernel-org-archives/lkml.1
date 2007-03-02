Return-Path: <linux-kernel-owner+w=401wt.eu-S1422646AbXCBADR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422646AbXCBADR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 19:03:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161304AbXCBACr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 19:02:47 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:13743 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161261AbXCBACi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 19:02:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HzRunlHJ64OmH/HWhUrREJzr9jR6n+5LSs6r4QhZNGL3+gcjbN6nkmrubiey983NOr8eDQHo55XuAX5Y96vwLN9S68awz+/vWFXEDke0jX/VxfnVLeNWcb4ZNwxjajPMujmpap35B6hipYsN0lIhVb+AdlzkWI65Vodrur7fbKE=
Message-ID: <45a44e480703011602j698f67dev469b49d6b527f502@mail.gmail.com>
Date: Thu, 1 Mar 2007 19:02:34 -0500
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "Paul Mundt" <lethal@linux-sh.org>,
       "Jaya Kumar" <jayakumar.lkml@gmail.com>,
       linux-fbdev-devel@lists.sourceforge.net, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH/RFC 2.6.20 1/2] fbdev, mm: Deferred IO support
In-Reply-To: <20070301140131.GA6603@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070225051312.17454.80741.sendpatchset@localhost>
	 <20070301140131.GA6603@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/1/07, Paul Mundt <lethal@linux-sh.org> wrote:
> On Sun, Feb 25, 2007 at 06:13:12AM +0100, Jaya Kumar wrote:
> > This patch implements deferred IO support in fbdev. Deferred IO is a way to
> > delay and repurpose IO. This implementation is done using mm's page_mkwrite
> > and page_mkclean hooks in order to detect, delay and then rewrite IO. This
> > functionality is used by hecubafb.
> >
> Any updates on this? If there are no other concerns, it would be nice to
> at least get this in to -mm for testing if nothing else.

I think Andrew merged it into -mm.

>
> Jaya, can you roll the fsync() patch in to your defio patch? There's not
> much point in keeping them separate.
>

I forgot to add that. Sorry about that. Should I resubmit with it or
would you prefer to post it?

Thanks,
jaya
