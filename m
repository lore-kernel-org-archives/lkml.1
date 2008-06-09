Return-Path: <linux-kernel-owner+w=401wt.eu-S1758072AbYFICnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072AbYFICnT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 22:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756025AbYFICnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 22:43:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755918AbYFICnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 22:43:11 -0400
Date: Sun, 8 Jun 2008 22:42:28 -0400
From: Rik van Riel <riel@redhat.com>
To: "MinChan Kim" <minchan.kim@gmail.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lee.schermerhorn@hp.com, kosaki.motohiro@jp.fujitsu.com,
       "Hugh Dickins" <hugh@veritas.com>
Subject: Re: [PATCH -mm 04/25] free swap space on swap-in/activation
Message-ID: <20080608224228.6465f222@bree.surriel.com>
In-Reply-To: <28c262360806081914v357f4093ra1e1e9e36f487eb7@mail.gmail.com>
References: <20080606202838.390050172@redhat.com>
	<20080606202858.570020389@redhat.com>
	<20080606180430.38bf1d82.akpm@linux-foundation.org>
	<28c262360806081914v357f4093ra1e1e9e36f487eb7@mail.gmail.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2008 11:14:55 +0900
"MinChan Kim" <minchan.kim@gmail.com> wrote:

> > - Can completely optimise the thing away if !CONFIG_SWAP.

> How about your opinion ?

You are right that it can be done.  However, doing all of those
!CONFIG_SWAP optimizations are not my priority right now.  Most
of them would also apply separately to the current upstream VM.

Patches are welcome, though.

-- 
All rights reversed.
