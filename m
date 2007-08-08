Return-Path: <linux-kernel-owner+w=401wt.eu-S935811AbXHHTco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935811AbXHHTco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 15:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761550AbXHHTcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 15:32:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759661AbXHHTcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 15:32:33 -0400
Date: Wed, 8 Aug 2007 15:32:20 -0400
From: Bill Nottingham <notting@redhat.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dtor@insightbb.com>
Subject: Re: 2.6.22: pcspkr driver no longer loads automatically
Message-ID: <20070808193220.GB5001@nostromo.devel.redhat.com>
Mail-Followup-To: Kay Sievers <kay.sievers@vrfy.org>,
	Chuck Ebbert <cebbert@redhat.com>, Jeff Garzik <jeff@garzik.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Dmitry Torokhov <dtor@insightbb.com>
References: <46B8C8FA.9020100@redhat.com> <46B8D984.7040602@garzik.org> <46B8E773.5020406@redhat.com> <3ae72650708071523s24d80ae4v2590c50aea04c850@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ae72650708071523s24d80ae4v2590c50aea04c850@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers (kay.sievers@vrfy.org) said: 
> It doesn't have any aliases, so seems it was never autoloaded.

It was - prior kernels loaded it via the uevent generated from 
/devices/platform/pcspkr. Newer kernels seem to never actually
trigger a uevent from that (tested with a combination of
udevmonitor and 'udevtrigger --subsystem-match=platform'.)

Bill
