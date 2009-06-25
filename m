Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973AbZFYLcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbZFYLcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 07:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbZFYLcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 07:32:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39218 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750984AbZFYLcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 07:32:46 -0400
Date: Thu, 25 Jun 2009 12:34:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Dianne Hackborn <hackbod@android.com>, Daniel Walker <dwalker@fifo99.com>,
       Arve =?ISO-8859-14?B?SGr4bm5lduVn?= <arve@android.com>,
       Brian Swetland <swetland@google.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] staging: android: binder: Remove some funny &&
 usage
Message-ID: <20090625123402.1fac5aba@lxorguk.ukuu.org.uk>
In-Reply-To: <1245924848.12994.26.camel@localhost.localdomain>
References: <1244832678-30329-1-git-send-email-dwalker@fifo99.com>
	<4A390B9A.40806@goop.org>
	<1245254936.5982.261.camel@desktop>
	<4A391A54.7000109@goop.org>
	<d6200be20906171426n71979124i4b359b6f4fc35d7e@mail.gmail.com>
	<1245274308.5982.268.camel@desktop>
	<a55d774e0906191220i7280fe77qb724037fb92fab86@mail.gmail.com>
	<1245451983.32124.25.camel@desktop>
	<d6200be20906191713n161d4281u1f43804e675e29ac@mail.gmail.com>
	<1245458940.32124.45.camel@desktop>
	<26b7c7380906242109id89b490m2c148ec0ac9b3696@mail.gmail.com>
	<1245924848.12994.26.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> To me it seems everything that you want from Binder is already possible
> with D-Bus. Seems the only missing piece is to create dbus-daemon as a
> kernel subsystem so it is available for all userspace processes from the
> beginning (including init/upstart).

You don't even need that - you can start dbus immediately as part of init
if it makes you happy.

