Return-Path: <linux-kernel-owner+w=401wt.eu-S1758346AbZAHKNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758346AbZAHKNl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 05:13:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbZAHKNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 05:13:33 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:45520 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbZAHKNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 05:13:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=eSmH6utueTY5q6iMDTry+pB4y+v/wBPBM2rBdi5SqPtCDFYnAa9/4pwA9z76Yi7ANa
         ezB6VGXHLLKTxDPU3GA1hV+8FBtEypO77Z68YiNrr6TX3VRdjpPc/zYfeAdJjhLMy5/l
         /4epk1JGQ2NCLpqqS/kBwNbv6qWlB0T4Z8I6k=
Subject: Re: [PATCH 1/3] w35und: Move ETH_LENGTH_OF_ADDRESS to wbhal_s.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Greg Kroah-Hartman <greg@kroah.com>, Pavel Machek <pavel@suse.cz>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1231408613.9373.5.camel@penberg-laptop>
References: <Pine.LNX.4.64.0901081130160.15334@melkki.cs.Helsinki.FI>
	 <1231408018.5539.6.camel@brick>  <1231408613.9373.5.camel@penberg-laptop>
Content-Type: text/plain
Date: Thu, 08 Jan 2009 02:13:30 -0800
Message-Id: <1231409610.5539.7.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-08 at 11:56 +0200, Pekka Enberg wrote:
> On Thu, 2009-01-08 at 01:46 -0800, Harvey Harrison wrote:
> > On Thu, 2009-01-08 at 11:30 +0200, Pekka J Enberg wrote:
> > > From: Pekka Enberg <penberg@cs.helsinki.fi>
> > >  
> > > +#define ETH_LENGTH_OF_ADDRESS 6
> > 
> > Or just use ETH_ALEN like the rest of the kernel and drop this guy.
> 
> Even better, thanks Harvey! Greg, please use this one instead. The rest
> of the series is unaffected by the changes in this patch.
> 
> >From c849ed5b5e68953a72f8dc43066513f118822f94 Mon Sep 17 00:00:00 2001
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> Date: Thu, 8 Jan 2009 11:10:06 +0200
> Subject: [PATCH] w35und: convert code to use ETH_ALEN
> 
> As suggested by Harvey Harrison, convert driver to use ETH_ALEN and kill a
> private macro from common.h that is used for the same thing.

Untested, but obviously ACK the approach :-)

Harvey

