Return-Path: <linux-kernel-owner+w=401wt.eu-S1757412AbYE0SRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412AbYE0SRe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 14:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757755AbYE0SRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 14:17:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757522AbYE0SRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 14:17:14 -0400
Date: Tue, 27 May 2008 14:14:47 -0400
From: Alan Cox <alan@redhat.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Alan Cox <alan@redhat.com>,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] video4linux: Push down the BKL
Message-ID: <20080527181447.GB17790@devserv.devel.redhat.com>
References: <20080522223700.2f103a14@core> <20080526135951.7989516d@gaivota> <20080526202317.GA12793@devserv.devel.redhat.com> <20080526181027.1ff9c758@gaivota> <20080526220154.GA15487@devserv.devel.redhat.com> <20080527101039.1c0a3804@gaivota> <20080527094144.1189826a@bike.lwn.net> <20080527133100.6a9302fb@gaivota>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080527133100.6a9302fb@gaivota>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2008 at 01:31:00PM -0300, Mauro Carvalho Chehab wrote:
> It is safer to have a tool to test and stress the driver before going to
> production.

Stress testing is rarely useful here - things like ioctl races you find by
thinking evil thoughts. Stress tests that fail obviously help find some stuff
but its error cases and hotplug corner cases that are usually the most foul
