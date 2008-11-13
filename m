Return-Path: <linux-kernel-owner+w=401wt.eu-S1752831AbYKMLYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbYKMLYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 06:24:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbYKMLYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 06:24:13 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37223 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712AbYKMLYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 06:24:12 -0500
Date: Thu, 13 Nov 2008 09:24:09 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Olaf van der Spek <olafvdspek@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Unix sockets via TCP on localhost: is TCP slower?
Message-ID: <20081113112409.GK13263@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Olaf van der Spek <olafvdspek@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <b2cc26e40811121520k711fa702u85e53bbc18b021a0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2cc26e40811121520k711fa702u85e53bbc18b021a0@mail.gmail.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Nov 13, 2008 at 12:20:44AM +0100, Olaf van der Spek escreveu:
> Hi,
> 
> Quite often in discussions, I see people claiming Unix sockets are
> faster then TCP sockets on a connection that stays inside localhost.
> Let's say from app A to app B.
> Is this indeed the case and if so, how much and why?
> My assumption is that the kernel can optimize the 'connection' and let
> any performance differences disappear.

How much? Please measure. Faster? Not necessarily, Nagle comes to mind,
among others. What kind of traffic? That matters too.

Start here: http://en.wikipedia.org/wiki/Nagle's_algorithm

- Arnaldo
