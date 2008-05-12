Return-Path: <linux-kernel-owner+w=401wt.eu-S1761433AbYELKXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761433AbYELKXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 06:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761297AbYELKXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 06:23:31 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:24553 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761278AbYELKX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 06:23:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=izSvJMtwgE/bmPLv0uO6hTPNQpnP6O/aVnLMeHX8qPJNrXwh99B5F7VKK0LQqCdgu2gNrJ01Z/L53XOQa1iOB89O9hvei2OUixcVg/aVlpBUsbZMjGRcexf2F0Cc7PjTPv83O4SYDSS03YbOInVAP9N8p5LpkL66WPyUUHXzzcs=
Message-ID: <84144f020805120323x38e5c657v97e4aec8d334de6f@mail.gmail.com>
Date: Mon, 12 May 2008 13:23:28 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [patch 21/21] slab defrag: Obsolete SLAB
Cc: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "Rik van Riel" <riel@redhat.com>,
       "Christoph Lameter" <clameter@sgi.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "Mel Gorman" <mel@skynet.ie>, mpm@selenic.com,
       "Matthew Wilcox" <matthew@wil.cx>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <20080512100846.GI31954@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080510030831.796641881@sgi.com>
	 <20080510030919.604216074@sgi.com> <4825709A.2020407@firstfloor.org>
	 <20080510221515.3540a6cc@bree.surriel.com>
	 <2f11576a0805120038s334dc56cuaf16b8b7c6f87098@mail.gmail.com>
	 <84144f020805120054t1370236ei5ff52279457e026e@mail.gmail.com>
	 <20080512100846.GI31954@one.firstfloor.org>
X-Google-Sender-Auth: 83a60ae986f79861
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 1:08 PM, Andi Kleen <andi@firstfloor.org> wrote:
> > Christoph fixed a tbench regression that was in the same ballpark as
> > the TPC regression reported by Matthew which is why we've asked the
> > Intel folks to re-test. But yeah, we're working on it.
>
>  What are your plans to fix it?

I don't have a reproducable test and my boxes are so tiny the issues
probably won't show up anyway. So all I can do at this point is to
make sure Matthew et al can easily re-test whenever we fix some other
regression that potentially affects his workload.

I only recently started tracking this issue so I have no idea where
we're at with this. Christoph? Matthew?
