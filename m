Return-Path: <linux-kernel-owner+w=401wt.eu-S1753291AbZKKGgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbZKKGgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 01:36:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbZKKGgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 01:36:24 -0500
Received: from 1wt.eu ([62.212.114.60]:50988 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238AbZKKGgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 01:36:23 -0500
Date: Wed, 11 Nov 2009 07:36:17 +0100
From: Willy Tarreau <w@1wt.eu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
       Avi Kivity <avi@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091111063617.GD560@1wt.eu>
References: <20091110205445.GB1407@ucw.cz> <20091110211259.GD26633@1wt.eu> <4AF9D8E2.7050205@zytor.com> <20091110220652.GE26633@1wt.eu> <4AF9E61B.5090407@zytor.com> <20091110222031.GA22911@elte.hu> <20091110224222.GA28648@1wt.eu> <4AF9ED78.3000106@zytor.com> <20091111055220.GA560@1wt.eu> <4AFA569E.9040206@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFA569E.9040206@zytor.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 10:15:58PM -0800, H. Peter Anvin wrote:
> On 11/10/2009 09:52 PM, Willy Tarreau wrote:
> > 
> >   - last, the probability of having an NX page just after an
> >     executable one seems too tight to me to even constitute
> >     an attack vector ! BTW, I'm not even certain that all CPUs
> >     correctly implement this check !
> > 
> 
> Do you have *any* *evidence* *whatsoever* for that assertion?!

No, just basic feeling based on implementation cost and difficulty
vs gains as I explained.

> I personally will consider something that doesn't implement proper
> security check to be a potential security hole and will NAK the patch.

Even in the case of the NOPL instruction ? I clearly don't see
the potential security hole !

Willy

