Return-Path: <linux-kernel-owner+w=401wt.eu-S1758605AbYH0Q5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605AbYH0Q5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 12:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755247AbYH0Q5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 12:57:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35591 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752659AbYH0Q5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 12:57:11 -0400
Date: Wed, 27 Aug 2008 17:39:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 00/59] Introduce credentials
Message-ID: <20080827173950.02afc804@lxorguk.ukuu.org.uk>
In-Reply-To: <21723.1219847044@redhat.com>
References: <20080827143355.5b8bfcf1@lxorguk.ukuu.org.uk>
	<20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
	<21723.1219847044@redhat.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We get a number of things:
> 
>  (1) Multiple credential changes all happen simultaneously (setresuid() for
>      example).  The new set of credentials is committed with a single RCU
>      assignment.

Makes sense - except for the question of bounding memory utilisation.

> > I've never seen credentials of any kind showing in profiles so why do we
> > need this ?
> 
> I'm not sure what you mean by that.  Are you talking abo

Sorry I was assuming this was performance driven in fact the reasons are
totally different.

