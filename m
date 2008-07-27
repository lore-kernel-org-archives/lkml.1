Return-Path: <linux-kernel-owner+w=401wt.eu-S1755787AbYG0LcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787AbYG0LcS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 07:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbYG0LcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 07:32:08 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:54725 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbYG0LcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 07:32:05 -0400
Date: Sun, 27 Jul 2008 12:32:00 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Rufus & Azrael <rufus-azrael@numericable.fr>
cc: Al Viro <viro@zeniv.linux.org.uk>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.26-git15] Cannot open "/proc/sys/net/ipv4/route/flush"
In-Reply-To: <488C5545.5010309@numericable.fr>
Message-ID: <Pine.LNX.4.64.0807271228060.12405@blonde.site>
References: <488C5545.5010309@numericable.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jul 2008, Rufus & Azrael wrote:
> 
> After compiling the very latest git kernel this morning, I have this message
> on boot (on Gentoo box) :
> 
> Bringing up interface lo
>     127.0.0.1/8 ...
>     Adding routes
>         127.0.0.0/8 via 127.0.0.1 ...
> Cannot open "/proc/sys/net/ipv4/route/flush"
> 
> Do I put
> /proc/sys/net/ipv4/route/flush=1
> or
> net.ipv4.conf.all.accept_source_route = 1
> 
> in my sysctl.conf file ?

If I may answer a different question, I believe you need Al Viro's
[PATCH] lost sysctl fix
http://lkml.org/lkml/2008/7/27/7
and
[PATCH] missing bits of net-namespace / sysctl
http://lkml.org/lkml/2008/7/27/61

Hugh
