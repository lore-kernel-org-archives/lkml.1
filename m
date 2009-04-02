Return-Path: <linux-kernel-owner+w=401wt.eu-S932830AbZDBSn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830AbZDBSn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 14:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932210AbZDBSnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 14:43:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60309 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765815AbZDBSnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 14:43:17 -0400
Date: Thu, 2 Apr 2009 19:44:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christophe Lermytte <christophe.lermytte@thomson.net>,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: mutex_lock_slowpath warning using mxser tty driver
 (input/output error)
Message-ID: <20090402194401.154bbc36@lxorguk.ukuu.org.uk>
In-Reply-To: <1238696349.5133.25.camel@laptop>
References: <1238689565.14822.99.camel@thom>
	<1238696349.5133.25.camel@laptop>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It appears to want to lock a mutex in interrupt context, something
> that's a definite no-no.
> 
> CCed the folks who might know a thing or two about the driver.

Moxa is not a USB driver so the USB trace at the end makes no sense at
all.

Alan
