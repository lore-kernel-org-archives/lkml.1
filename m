Return-Path: <linux-kernel-owner+w=401wt.eu-S1756858AbZJLO0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbZJLO0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 10:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756828AbZJLO0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 10:26:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:37164 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756769AbZJLO0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 10:26:37 -0400
Date: Mon, 12 Oct 2009 07:26:42 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Christian Pernegger <pernegger@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: *Really* bad I/O latency with md raid5+dm-crypt+lvm
Message-ID: <20091012072642.3a06a271@infradead.org>
In-Reply-To: <bb145bd20910120701p70c176d9p85028da7afec094c@mail.gmail.com>
References: <bb145bd20910120701p70c176d9p85028da7afec094c@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009 16:01:58 +0200
Christian Pernegger <pernegger@gmail.com> wrote:

> [Please keep me CCed as I'm not subscribed to LKML]
> 
> Summary: I was hoping to use a layered storage setup, namely lvm on
> dm-crypt on md raid5 for a new box I'm setting up, but that isn't
> looking so good since a single heavyish writer will monopolise any and
> all I/O on the "device". F. ex. while cp'ing a few GB of data from an
> external disk to the array it takes ~10sec to run ls and ~2min to
> start aptitude. Clueless attempts at a diagnosis below.


have you ran latencytop ?
