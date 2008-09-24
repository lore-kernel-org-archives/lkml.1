Return-Path: <linux-kernel-owner+w=401wt.eu-S1754634AbYIXKXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbYIXKXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 06:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832AbYIXKXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 06:23:10 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34509 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754743AbYIXKXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 06:23:08 -0400
Date: Wed, 24 Sep 2008 11:22:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: sqazi@google.com (Salman Qazi)
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: mlock: Make the mlock system call interruptible by fatal
Message-ID: <20080924112255.64304a64@lxorguk.ukuu.org.uk>
In-Reply-To: <20080923224751.GA2790@google.com>
References: <20080923224751.GA2790@google.com>
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

> > Can we do
> >
> >        return i ? i : -EINTR;
> >
> > in the usual fashion?
> 
> Fixed.

If its only interruptible by fatal signals why do we care what the return
is ?

Alan (confused)
