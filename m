Return-Path: <linux-kernel-owner+w=401wt.eu-S1756305AbYGKQSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305AbYGKQSr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 12:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753903AbYGKQSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 12:18:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333AbYGKQSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 12:18:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080711155113.256e89d1@lxorguk.ukuu.org.uk>
References: <20080711155113.256e89d1@lxorguk.ukuu.org.uk> <20080711145201.24870.13609.stgit@warthog.procyon.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: dhowells@redhat.com, alan@redhat.com, akpm@linux-foundation.org,
       linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MN10300: Fix MN10300's serial port driver to get at its tty_struct
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Fri, 11 Jul 2008 17:17:58 +0100
Message-ID: <25350.1215793078@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> I don't suppose you'd consider putting the driver into drivers/serial so
> it was actually sanely possible to update all the tty drivers together.
> There are lots more changes to come and it would be easier if drivers
> didn't keep hiding 8(

Do you want a bunch of .S files moving in there?

David
