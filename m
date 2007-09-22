Return-Path: <linux-kernel-owner+w=401wt.eu-S1762297AbXIVGsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762297AbXIVGsy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 02:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755769AbXIVGsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 02:48:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56936 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477AbXIVGsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 02:48:46 -0400
Date: Sat, 22 Sep 2007 12:21:42 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Mel Gorman <mel@skynet.ie>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: 2.6.23-rc6-mm1: Build failures on ppc64_defconfig
In-Reply-To: <alpine.LFD.0.999.0709201903180.17093@enigma.security.iitk.ac.in>
Message-ID: <alpine.LFD.0.999.0709221221060.22517@enigma.security.iitk.ac.in>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
 <20070920132512.GF24105@skynet.ie>
 <alpine.LFD.0.999.0709201903180.17093@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 20 Sep 2007, Satyam Sharma wrote:
> 
> BTW ppc64_defconfig didn't quite like 2.6.23-rc6-mm1 either ...
> IIRC I got build failures in:

> drivers/md/raid6int8.c

This turned out to be a gcc bug -- I was using an old cross-compiler.
