Return-Path: <linux-kernel-owner+w=401wt.eu-S1758413AbZKJWmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758413AbZKJWmd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 17:42:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757989AbZKJWmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 17:42:32 -0500
Received: from 1wt.eu ([62.212.114.60]:50967 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456AbZKJWmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 17:42:32 -0500
Date: Tue, 10 Nov 2009 23:42:23 +0100
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@ucw.cz>,
       Avi Kivity <avi@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091110224222.GA28648@1wt.eu>
References: <4AF9B5AB.5010800@zytor.com> <4AF9C3EF.6000705@redhat.com> <4AF9C6AB.8080006@zytor.com> <20091110201602.GA26633@1wt.eu> <20091110205445.GB1407@ucw.cz> <20091110211259.GD26633@1wt.eu> <4AF9D8E2.7050205@zytor.com> <20091110220652.GE26633@1wt.eu> <4AF9E61B.5090407@zytor.com> <20091110222031.GA22911@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091110222031.GA22911@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 11:20:31PM +0100, Ingo Molnar wrote:
> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
> > *THIS* is the kind of complexity that makes me think that having a 
> > single source for all interpretation done in the kernel is the 
> > preferred option.
> 
> Definitely agreed ... The NX code is quite a maze right now, so changes 
> to it should come generously laced with cleanups.

BTW, I don't see why we should be impacted by NX. Trying to
execute from an NX page would return a SEGV, not SIGILL, so
we should not be bothered, am I wrong ?

Willy

