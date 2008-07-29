Return-Path: <linux-kernel-owner+w=401wt.eu-S1757582AbYG2TMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582AbYG2TMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 15:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbYG2TMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 15:12:41 -0400
Received: from gw.goop.org ([64.81.55.164]:49647 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbYG2TMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 15:12:40 -0400
Message-ID: <488F6BA1.4030708@goop.org>
Date: Tue, 29 Jul 2008 12:12:33 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Cliff Wickman <cpw@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, steiner@sgi.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: Comments on UV tlb flushing
References: <488E644B.10801@goop.org>	 <200807291412.18495.nickpiggin@yahoo.com.au>	 <20080729133204.GA13138@sgi.com> <488F2C9B.9070306@goop.org> <86802c440807291113u59ba996dg340c8feba1039f3a@mail.gmail.com> <488F60A1.2080902@goop.org> <488F6563.4000907@sgi.com>
In-Reply-To: <488F6563.4000907@sgi.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> Should there be a "generic" X86_ENTERPRISE_ARCH which turns on various
> capabilities?  Our licenses and support agreements with SuSE and RH are
> for their "Enterprise Editions" though the customer is free to run
> whatever (unsupported from us).  Asking distros to enable that option
> should be a no-brainer.  And it could be defaulted ON with the comment
> to turn it off if you have a small desktop system.  This way they won't
> forget... ;-)  [Actually, this could turn on MAXSMP as well.]
>   

I don't have a strong opinion, but I suspect that distros actually pay 
attention to each option being set, since they end up having to support 
them all anyway.  As such, they'd generally prefer to explicitly turn 
each thing on or off themselves, and big-switch config options aren't 
all that useful.

But you would have to talk to a distro person to get confirmation ;)

    J
