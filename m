Return-Path: <linux-kernel-owner+w=401wt.eu-S1756203AbXFYNkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbXFYNkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 09:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753045AbXFYNk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 09:40:29 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:2629 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755938AbXFYNk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 09:40:27 -0400
Date: Mon, 25 Jun 2007 15:40:37 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: David Woodhouse <dwmw2@infradead.org>
cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] cross-architecture ELF clean up
In-Reply-To: <1182762166.12109.19.camel@pmac.infradead.org>
Message-ID: <Pine.LNX.4.64.0706251538540.4386@scrub.home>
References: <20070620230854.246399397@goop.org>  <20070620230902.387008536@goop.org>
 <1182762166.12109.19.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 25 Jun 2007, David Woodhouse wrote:

> On Wed, 2007-06-20 at 16:08 -0700, Jeremy Fitzhardinge wrote:
> > This patch cleans up the ELF headers and their users.  It does several
> > related things:
> 
> Looks good. We can get away with exporting a lot less of this to
> userspace too, can't we?

glibc provides its own version, so it doesn't has to be exported at all.

bye, Roman
