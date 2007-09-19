Return-Path: <linux-kernel-owner+w=401wt.eu-S1763810AbXISR5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763810AbXISR5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbXISR5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:57:04 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39092 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbXISR5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:57:01 -0400
Date: Wed, 19 Sep 2007 19:57:00 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, netdev <netdev@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: follow-up: discrepancy with POSIX
Message-ID: <20070919175700.GC18045@one.firstfloor.org>
References: <46F13E8B.4050309@redhat.com> <p73sl5aveqh.fsf@bingen.suse.de> <46F15305.2030507@redhat.com> <20070919172653.GB18045@one.firstfloor.org> <46F1608E.7060908@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F1608E.7060908@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2007 at 10:46:54AM -0700, Ulrich Drepper wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Andi Kleen wrote:
> >> But the spec calls for a "null address" to be used and that's in my
> >> understanding something different from using AF_UNSPEC.
> > 
> > memset(&sockaddr, 0, sizeof(sockaddr)) should give you AF_UNSPEC
> 
> But the spec calls for <quote>null address for the protocol</quote>.
> 
> That means the family for the null address is the same as the family of
> the socket.

Spec doesn't match traditional behaviour then. IPv4 0.0.0.0 is 
traditionally an synonym for old style all broadcast (255.255.255.255) 
on UDP/RAW and it's certainly possible to connect() to that. 

-Andi
