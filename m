Return-Path: <linux-kernel-owner+w=401wt.eu-S933040AbZHZNqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933040AbZHZNqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 09:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933019AbZHZNqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 09:46:10 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37814 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933018AbZHZNqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 09:46:10 -0400
Date: Wed, 26 Aug 2009 14:47:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Chris Adams <cmadams@hiwaay.net>
Cc: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: [patch] document flash/RAID dangers
Message-ID: <20090826144716.486a0d44@lxorguk.ukuu.org.uk>
In-Reply-To: <20090826134045.GA1516467@hiwaay.net>
References: <dddMw-7Xt-57@gated-at.bofh.it>
	<dddWc-83W-51@gated-at.bofh.it>
	<ddefx-5R-37@gated-at.bofh.it>
	<ddep7-bI-7@gated-at.bofh.it>
	<ddeyR-iy-11@gated-at.bofh.it>
	<ddeyR-iy-9@gated-at.bofh.it>
	<ddeIu-n9-9@gated-at.bofh.it>
	<ddeSb-th-29@gated-at.bofh.it>
	<ddoRI-11a-39@gated-at.bofh.it>
	<ddpkB-1jQ-1@gated-at.bofh.it>
	<20090826134045.GA1516467@hiwaay.net>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The issues being raised here are not specific to extX, MD RAID, or Linux
> at all; they are problems with non-"enterprise-class" RAID setups.
> There's a reason enterprise-class RAID costs a lot more money than the
> card you can pick up at Fry's.

And you will still need backups ;)

A long time ago I worked on a fault tolerant news server with dual
alphaserver boxes and a shared disk array. A power system failure took
out both the alpha boxes and the disk controllers and all the disks.

Fortunately it was a news server so you just had to wait a week ..

Alan
