Return-Path: <linux-kernel-owner+w=401wt.eu-S1755130AbZKIJwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130AbZKIJwe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 04:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754890AbZKIJwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 04:52:34 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59576 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754767AbZKIJwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 04:52:33 -0500
Date: Mon, 9 Nov 2009 09:53:16 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Daniel Mack <daniel@caiaq.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vt: make the default cursor shape configurable
Message-ID: <20091109095316.6283fbd6@lxorguk.ukuu.org.uk>
In-Reply-To: <4AF7DDC1.4090006@ladisch.de>
References: <4AF7D439.4030305@ladisch.de>
	<20091109091044.GX29442@buzzloop.caiaq.de>
	<4AF7DDC1.4090006@ladisch.de>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Nov 2009 10:15:45 +0100
Clemens Ladisch <clemens@ladisch.de> wrote:

> Make the default console cursor type configurable rather than
> hard-coding it.

You can set the cursor type at runtime so this all seems unjustified and
doing this kind of thing at build time is definitely the wrong place.

Alan
