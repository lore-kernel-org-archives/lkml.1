Return-Path: <linux-kernel-owner+w=401wt.eu-S1762725AbXGKBTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762725AbXGKBTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 21:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbXGKBT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 21:19:27 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:2724 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685AbXGKBT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 21:19:26 -0400
From: Roman Zippel <zippel@linux-m68k.org>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: [PATCH] LinuxPPS (with new syscalls API) - new version
Date: Wed, 11 Jul 2007 03:18:46 +0200
User-Agent: KMail/1.9.7
Cc: Rodolfo Giometti <giometti@enneenne.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <1183031060.1170.145.camel@pmac.infradead.org> <20070701192441.GW13886@enneenne.com> <20070710160151.GB31195@csclub.uwaterloo.ca>
In-Reply-To: <20070710160151.GB31195@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707110318.49244.zippel@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 10 July 2007, Lennart Sorensen wrote:

> On Sun, Jul 01, 2007 at 09:24:41PM +0200, Rodolfo Giometti wrote:
> >     struct pps_timedata_s {
> >        __32 sec;
> >        __32 nsec;
> >     }
> >
> > Ok? I think 32 bits are enought for keeping seconds... :)
>
> You want to purposely define an API that will break in 23 years (or is
> that 83 years since you made it unsigned potentially)?

This is really not an API that needs to deal with such large time range.

bye, Roman
