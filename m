Return-Path: <linux-kernel-owner+w=401wt.eu-S1757287AbZCLP2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287AbZCLP2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 11:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbZCLP2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 11:28:23 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:17857 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702AbZCLP2W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 11:28:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=lC2BqyClfPdM2wXKa3jMr0CW9xxZcDtssmrEsW2LgWcLQO4L/+5ZlOxAkTVuf38A6Y
         57YWt7U9xusqPPKAiCDIqoOORe1Ld08uzNakFfBuubTlqNVlhUjBaM7/ad+mgE3Oa/xC
         AUicYiw35GbV2CoFAeIGaJaSbqiI2ARySOkuU=
From: Diego Calleja <diegocg@gmail.com>
To: Daniel Phillips <phillips@phunq.net>
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
Date: Thu, 12 Mar 2009 16:30:19 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc7-00143-g99adcd9; KDE/4.2.1; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, tux3@tux3.org,
       linux-kernel@vger.kernel.org
References: <200903110925.37614.phillips@phunq.net> <20090311230713.d4710050.akpm@linux-foundation.org> <200903120133.02645.phillips@phunq.net>
In-Reply-To: <200903120133.02645.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903121630.19648.diegocg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jueves 12 Marzo 2009 09:33:02 Daniel Phillips escribió:
> > umm, it _is_ primarily kernel code, after all.  So it seems appropriate
> > to use BUG_ON() and printk(), etc and to provide versions of those for
> > the userspace incarnation?
> 
> Will do.

btrfs-progs also runs some btrfs kernel code in userspace, tux3 could reuse
their "compatibility layer", it can be found at btrfs-progs/kerncompat.h
