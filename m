Return-Path: <linux-kernel-owner+w=401wt.eu-S1757755AbZCZNFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755AbZCZNFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 09:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754805AbZCZNFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 09:05:08 -0400
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:47988 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752296AbZCZNFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 09:05:06 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-01.arcor-online.net 481E2332D1D
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [dm-devel] Barriers still not passing on simple dm devices...
To: Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       device-mapper development <dm-devel@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>,
       ?missing.closing.'"' in token?"MASON",
	CHRISTOPHER <CHRIS.MASON@oracle.com>"@vax.1wt.eu
Illegal-Object: Syntax error in To: address found on vger.kernel.org:
	To:	?missing closing '"' in token?"MASON", CHRISTOPHER <CHRIS.MASON@oracle.com>"
			^				    ^-missing closing '"' in token
		 \-extraneous tokens in address
Illegal-Object: Syntax error in To: address found on vger.kernel.org:
	To:	?missing closing '"' in token?"MASON", CHRISTOPHER <CHRIS.MASON@oracle.com>"
			^				    ^-missing closing '"' in token
		 \-extraneous tokens in address
Reply-To: 7eggert@gmx.de
Date: Thu, 26 Mar 2009 14:05:00 +0100
References: <ciXHh-39c-37@gated-at.bofh.it> <cjfuL-6vJ-43@gated-at.bofh.it> <cjfEl-6J2-45@gated-at.bofh.it> <cjfNX-6Wh-27@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1LmpGX-0001gP-6q@be1.7eggert.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikulas Patocka <mpatocka@redhat.com> wrote:

> ./drivers/block/loop.c:
> doesn't reject barriers, it's ok because it doesn't reorder requests

But it relies on other devices to not reorder.

