Return-Path: <linux-kernel-owner+w=401wt.eu-S1757342AbXHEIH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342AbXHEIH3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 04:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756376AbXHEIHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 04:07:01 -0400
Received: from dsl081-085-152.lax1.dsl.speakeasy.net ([64.81.85.152]:47178
	"EHLO moonbase.phunq.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756243AbXHEIG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 04:06:59 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: Distributed storage.
Date: Sun, 5 Aug 2007 01:06:58 -0700
User-Agent: KMail/1.9.5
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
References: <20070731171347.GA14267@2ka.mipt.ru> <200708031741.18404.phillips@phunq.net> <20070804164438.GC14175@2ka.mipt.ru>
In-Reply-To: <20070804164438.GC14175@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708050106.58383.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 04 August 2007 09:44, Evgeniy Polyakov wrote:
> > On Tuesday 31 July 2007 10:13, Evgeniy Polyakov wrote:
> > >     * storage can be formed on top of remote nodes and be
> > > exported simultaneously (iSCSI is peer-to-peer only, NBD requires
> > > device mapper and is synchronous)
> >
> > In fact, NBD has nothing to do with device mapper.  I use it as a
> > physical target underneath ddraid (a device mapper plugin) just
> > like I would use your DST if it proves out.
>
> I meant to create a storage on top of several nodes one needs to have
> device mapper or something like that on top of NBD itself. To further
> export resulted device one needs another userspace NDB application
> and so on. DST simplifies that greatly.
>
> DST original code worked as device mapper plugin too, but its two
> additional allocations (io and clone) per block request ended up for
> me as a show stopper.

Ah, sorry, I misread.  A show stopper in terms of efficiency, or in 
terms of deadlock?

Regards,

Daniel
