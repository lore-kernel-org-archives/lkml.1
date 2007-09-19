Return-Path: <linux-kernel-owner+w=401wt.eu-S1761178AbXISSaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761178AbXISSaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 14:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbXISSaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 14:30:07 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48978 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbXISSaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 14:30:05 -0400
Date: Wed, 19 Sep 2007 20:30:04 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, netdev <netdev@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: follow-up: discrepancy with POSIX
Message-ID: <20070919183004.GA18707@one.firstfloor.org>
References: <46F13E8B.4050309@redhat.com> <p73sl5aveqh.fsf@bingen.suse.de> <46F15305.2030507@redhat.com> <20070919172653.GB18045@one.firstfloor.org> <46F1608E.7060908@redhat.com> <20070919175700.GC18045@one.firstfloor.org> <46F16418.3070706@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F16418.3070706@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2007 at 11:02:00AM -0700, Ulrich Drepper wrote:
> > on UDP/RAW and it's certainly possible to connect() to that. 
> 
> Where do you get this from?  And where is this implemented?  I don't

Sorry it's actually loopback, not broadcast as implemented in Linux.
In Linux it's implemented in ip_route_output_slow(). Essentially
converted to 127.0.0.1

I think it's traditional BSD behaviour but couldn't find it on
a quick look in FreeBSD source (but haven't looked very intensively) 

Admittedly port 0 is somewhat dodgy for UDP too, but at least in RAW
context it might be valid.

-Andi
