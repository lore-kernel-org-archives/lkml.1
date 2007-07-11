Return-Path: <linux-kernel-owner+w=401wt.eu-S933416AbXGKWeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933416AbXGKWeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 18:34:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757079AbXGKWeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 18:34:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754667AbXGKWeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 18:34:00 -0400
Message-ID: <46955AD4.3000801@redhat.com>
Date: Wed, 11 Jul 2007 18:33:56 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: v@iki.fi
CC: linux-kernel@vger.kernel.org,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: 2.6.22 Oops attaching  usb-storage device
References: <20070711125957.GT22103@vianova.fi>
In-Reply-To: <20070711125957.GT22103@vianova.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2007 08:59 AM, Ville Herva wrote:
> [98790.134315] sd 17:0:0:0: [sdb] Mode Sense: 03 00 00 00
> [98790.134319] sd 17:0:0:0: [sdb] Assuming drive cache: write through
> [98790.134323]  sdb:<6>usb 6-1: USB disconnect, address 27
> [98790.366609] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000

Another USB device disconnect while scanning for partitions.

Yes, it should be handled but it also shouldn't just disconnect like that.
