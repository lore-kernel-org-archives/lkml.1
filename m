Return-Path: <linux-kernel-owner+w=401wt.eu-S1755732AbYJHUMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732AbYJHUMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 16:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbYJHUMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 16:12:35 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34009 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753087AbYJHUMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 16:12:34 -0400
Date: Wed, 8 Oct 2008 21:12:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Richard A. Holden III" <aciddeath@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       "Richard A. Holden III" <aciddeath@gmail.com>
Subject: Re: [PATCH 00/10] ixj: Cleanup dead and duplicate code
Message-ID: <20081008211232.3a14b4ea@lxorguk.ukuu.org.uk>
In-Reply-To: <cover.1223497216.git.aciddeath@gmail.com>
References: <cover.1223497216.git.aciddeath@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  8 Oct 2008 14:41:35 -0600
"Richard A. Holden III" <aciddeath@gmail.com> wrote:

> Cleanup dead code and duplicate code to start simplifying the ixj
> driver, currently it is around 10000 lines long. This has been built,
> but I don't have the hardware to test, most changes were fairly
> mechanical.

It needs doing but you need to be very very careful and I don't think
this is a good idea to merge untested because if you misprogram the SLIC
you can blow the card up, permanently,magic smoke gone, dead, defunct.

It's one card where we really really don't want to make untested changes.

That said if you've got an old box with an ISA slot somewhere, and a
postal address you can have the old ISA card that Quicknet provided for
testing - contact me off list if you want it.

Alan
