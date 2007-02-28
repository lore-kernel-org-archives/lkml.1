Return-Path: <linux-kernel-owner+w=401wt.eu-S1752369AbXB1Xif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369AbXB1Xif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 18:38:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbXB1Xie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 18:38:34 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:50042 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319AbXB1Xid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 18:38:33 -0500
Date: Thu, 1 Mar 2007 00:36:47 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Bill Irwin <bill.irwin@oracle.com>
cc: Andi Kleen <andi@firstfloor.org>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Wanted: simple, safe x86 stack overflow detection
In-Reply-To: <20070228232047.GB10643@holomorphy.com>
Message-ID: <Pine.LNX.4.61.0703010035590.23355@yvahk01.tjqt.qr>
References: <45E5913D.3080505@redhat.com> <20070228204144.GA32316@one.firstfloor.org>
 <20070228232047.GB10643@holomorphy.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 28 2007 15:20, Bill Irwin wrote:
>
>I don't know about the rest of the world, but halting the system in the
>case of memory corruption sounds like an extremely good idea to me.

Just because a rather "unimportant" driver (e.g. parport) might oops
thanks to a now-invalid address after memory corruption, I'd still like
to shutdown the system normally - which should be possible when not
using parport after said corruption.


Jan
-- 
ft: http://freshmeat.net/p/chaostables/
