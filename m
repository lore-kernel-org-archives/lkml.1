Return-Path: <linux-kernel-owner+w=401wt.eu-S932529AbXB1Xpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529AbXB1Xpp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 18:45:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932569AbXB1Xpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 18:45:45 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:27748 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932529AbXB1Xpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 18:45:45 -0500
Date: Wed, 28 Feb 2007 15:45:24 -0800
From: Bill Irwin <bill.irwin@oracle.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Bill Irwin <bill.irwin@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Wanted: simple, safe x86 stack overflow detection
Message-ID: <20070228234524.GC10643@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Andi Kleen <andi@firstfloor.org>, Chuck Ebbert <cebbert@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <45E5913D.3080505@redhat.com> <20070228204144.GA32316@one.firstfloor.org> <20070228232047.GB10643@holomorphy.com> <Pine.LNX.4.61.0703010035590.23355@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0703010035590.23355@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 28 2007 15:20, Bill Irwin wrote:
>> I don't know about the rest of the world, but halting the system in the
>> case of memory corruption sounds like an extremely good idea to me.

On Thu, Mar 01, 2007 at 12:36:47AM +0100, Jan Engelhardt wrote:
> Just because a rather "unimportant" driver (e.g. parport) might oops
> thanks to a now-invalid address after memory corruption, I'd still like
> to shutdown the system normally - which should be possible when not
> using parport after said corruption.

Panic on oops/bug is sysctl-activated as things now stand, so you're
all set.


-- wli
