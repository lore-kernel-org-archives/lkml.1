Return-Path: <linux-kernel-owner+w=401wt.eu-S932313AbXCUPeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313AbXCUPeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 11:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932368AbXCUPeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 11:34:06 -0400
Received: from csclub1.cs.uwaterloo.ca ([129.97.7.226]:59113 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932313AbXCUPeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 11:34:04 -0400
Date: Wed, 21 Mar 2007 11:34:02 -0400
To: Jon K Hellan <jon.kare.hellan@uninett.no>
Cc: Rodolfo Giometti <giometti@enneenne.com>, linux-kernel@vger.kernel.org,
       linuxpps@ml.enneenne.com
Subject: Re: [PATCH 1/1] LinuxPPS: Pulse per Second support for Linux
Message-ID: <20070321153402.GL22466@csclub.uwaterloo.ca>
References: <20070321074121.GA13843@enneenne.com> <4600E74E.7020606@uninett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4600E74E.7020606@uninett.no>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 09:05:34AM +0100, Jon K Hellan wrote:
> Have you received any comments on this from the NTP community? From 
> Ulrich Windl?

Well as just a user, this patch seems to work, and is actively being
worked on and maintained for modern kernels (which unforunately Ulrich
Windl's patch hardly appears to be).  

This one also seems much less intrusive, doesn't break serial console
systems (I sent a patch to Ulrich Windl to fix that, due to one of
many places where pointers are dereferenced without being checked for
!NULL first).

Is LinuxPPS better?  I have no idea, and I don't think I am qualified to
say one way or another.  I do know that I could apply it to 2.6.18 with
minimal work, while I couldn't get Ulrich Windl's patch to do so (too
much has changed since 2.6.15, while I did manage to get it to apply to
2.6.16 with quite a bit of work).

Having PPS support actually part of the kernel would make it much
simpler to deal with in the future, and perhaps ntp would start being
compiled with such support regularly.

--
Len Sorensen
