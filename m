Return-Path: <linux-kernel-owner+w=401wt.eu-S1756215AbXFLPQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbXFLPQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 11:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753663AbXFLPQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 11:16:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbXFLPQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 11:16:14 -0400
Subject: Re: ext3fs: umount+sync not enough to guarantee metadata-on-disk
From: "Stephen C. Tweedie" <sct@redhat.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Mark Lord <lkml@rtr.ca>, Andrew Morton <akpm@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Stephen Tweedie <sct@redhat.com>
In-Reply-To: <20070610182746.GA4272@ucw.cz>
References: <46680BB8.50404@rtr.ca>
	 <20070607084142.42583639.akpm@linux-foundation.org>
	 <46682BE7.6080802@rtr.ca>  <20070610182746.GA4272@ucw.cz>
Content-Type: text/plain
Organization: Red Hat UK Ltd, Amberley Place, 107-111 Peascod Street,
	Windsor, Berkshire, SL4 1TE, United Kingdom. Registered in England and
	Wales under Company Registration No. 03798903
Date: Tue, 12 Jun 2007 16:15:58 +0100
Message-Id: <1181661358.18067.28.camel@sisko.scot.redhat.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-35.0.2.el4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 2007-06-10 at 18:27 +0000, Pavel Machek wrote:

> > Once a f/s is read-only, there should be NO writing to 
> > it.  Right?
> 
> Linux happily writes to filesystems mounted read-only. It will replay
> journal on them.

Only at mount time, not on unmount; and it does check whether the
underlying device is truly readonly or not first (assuming
bdev_read_only() is working on the device in question.)

--Stephen


