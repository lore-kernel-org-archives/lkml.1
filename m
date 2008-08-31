Return-Path: <linux-kernel-owner+w=401wt.eu-S1758938AbYHaWUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938AbYHaWUU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 18:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754267AbYHaWUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 18:20:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59536 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752601AbYHaWUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 18:20:06 -0400
Date: Sun, 31 Aug 2008 23:02:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: David Miller <davem@davemloft.net>, "Dushan Tcholich" <dusanc@gmail.com>,
       "Francois Romieu" <romieu@fr.zoreil.com>,
       "Robert Hancock" <hancockr@shaw.ca>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, bridge@lists.linux-foundation.org
Subject: Re: [RFC] bridge: STP timer management range checking
Message-ID: <20080831230247.76b5a193@lxorguk.ukuu.org.uk>
In-Reply-To: <20080831104309.780cc01f@extreme>
References: <fa.wTMiBcGRgw2fBtdHwtX7y0lkc8s@ifi.uio.no>
	<48975BD3.6040709@shaw.ca>
	<a08621850808041337k1d1deb6fk78098d9fcd4930dd@mail.gmail.com>
	<20080807185802.GA16327@electric-eye.fr.zoreil.com>
	<a08621850808101200n220afd2dve58abe67830b7a4f@mail.gmail.com>
	<a08621850808110053j5cbf23e6xdf52c9e7440abf19@mail.gmail.com>
	<a08621850808291848q5660148fx57d576ecfcbfce8@mail.gmail.com>
	<a08621850808310151o143845h195a8658d02270d9@mail.gmail.com>
	<20080831100537.6929c51e@extreme>
	<20080831104309.780cc01f@extreme>
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

On Sun, 31 Aug 2008 10:43:09 -0700
Stephen Hemminger <shemminger@vyatta.com> wrote:

> The Spanning Tree Protocol timers need to be set within certain boundaries
> to keep the internal protocol engine working, and to be interoperable.
> This patch restricts changes to those timers to the values defined in IEEE 802.1D
> specification.

Why do we care ? You have to be the network administrator to set values,
there are cases you may want to be out of the spec and you are
privileged. The kernel does need to stop things being done which are
fatal but running around restricting privileged administrators who have
the ability to bring the network down anyway isn't its job.

Seems bogus extra code to me - stops things working that should be
allowed too.
