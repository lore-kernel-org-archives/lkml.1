Return-Path: <linux-kernel-owner+w=401wt.eu-S934760AbXKPBBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934760AbXKPBBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 20:01:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934201AbXKPBBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 20:01:37 -0500
Received: from simmts5-srv.bellnexxia.net ([206.47.199.163]:32975 "EHLO
	simmts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934196AbXKPBBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 20:01:36 -0500
From: Kevin Winchester <kjwinchester@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc2-mm1 -- strange apparent network failures
Date: Thu, 15 Nov 2007 21:01:32 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: apw@shadowen.org, linux-kernel@vger.kernel.org,
       Andrew Morgan <morgan@kernel.org>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org> <200711152028.29734.kjwinchester@gmail.com> <20071115164441.67a8e2df.akpm@linux-foundation.org>
In-Reply-To: <20071115164441.67a8e2df.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200711152101.33266.kjwinchester@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On November 15, 2007 08:44:41 pm Andrew Morton wrote:
> On Thu, 15 Nov 2007 20:28:29 -0400
>
> Kevin Winchester <kjwinchester@gmail.com> wrote:
> > On November 15, 2007 06:02:09 am Andy Whitcroft wrote:

> > I see this as well - the computer boots fine but no network.  The only
> > clues in the dmesg are:
> >
> > [  294.097876] warning: process `dhclient' gets w/ old libcap
> > [  294.097893] warning: process `dhclient' sets w/ old libcap
> >
> > So I'll try backing up the patch series to before:
> >
> > add-64-bit-capability-support-to-the-kernel.patch
>

That's the winner.  The changelog indicates that the patch is meant to keep 
compatibility with older userspace, so I guess it didn't quite keep as much 
compatibility as it wanted.

I have no idea what I'm doing, but I'll take a look at the patch anyway...

-- 
Kevin Winchester
