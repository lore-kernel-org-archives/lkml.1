Return-Path: <linux-kernel-owner+w=401wt.eu-S1755615AbYACQSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615AbYACQSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 11:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbYACQSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 11:18:06 -0500
Received: from wr-out-0506.google.com ([64.233.184.224]:3380 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbYACQSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 11:18:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HPRSErPJiIihMRIPFYXvor4YIyi2Srzvo+G1XhNDFy43l9DxXZz1vy0+pQtRwBTdtbIkpWdBTA9j9HSRGOQmkc4X+tCiAMvgRXV/2ZKnc/U9yO4xhdwCH9uS4PqwFvEPqMwQzMLiOmKhWNzTFNbJCxa3SL5bOgxmkAn4F/F09xg=
Message-ID: <4d8e3fd30801030817t7c468c66id5740ae06ae8a254@mail.gmail.com>
Date: Thu, 3 Jan 2008 19:47:59 +0330
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: New branch for +1 kernel Was:Re: [PATCH] Use __u64 in aligned_u64's definition
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       davem@davemloft.net, "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <477D0694.1010005@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4d8e3fd30801021441h51f180des465f94ed24b107c2@mail.gmail.com>
	 <477D0694.1010005@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/3/08, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> Paolo Ciarrocchi wrote:
> > This is something i was thinking to suggest.
> > Kernel is made of a lot of different "areas" and the regression list
> > is a great tool for monitoring every single area so why not opening a
> > new branch and accepting patches only for areas which are not in the
> > current regression list.?
>
> Some regressions can't be easily associated with an "area".  And when
> they can, consider the overhead involved with frequently kicking out
> patchsets and taking them in again, based on when regressions become
> known and when they are fixed, respectively.
>
> > Sounds like a good way to be more strict about regressions and
> > incentive people to solve regressions quicker.
>
> To create such a motivation, that branch or tree would have to have a
> practical use in development.  So what purpose would such a tree
> fulfill, considering that we already have a myriad of topic trees and
> the -mm tree for testing and preintegration?

That branch/tree would relax i bit the rule of "two weeks for merging
new stuff" for people who proven to have merged good quality code.

Ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
