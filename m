Return-Path: <linux-kernel-owner+w=401wt.eu-S1757478AbYDDQR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbYDDQR1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 12:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754477AbYDDQRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 12:17:17 -0400
Received: from ajlill.sentex.ca ([64.7.134.25]:45681 "EHLO
	freevo.ajlc.waterloo.on.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754090AbYDDQRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 12:17:16 -0400
X-Greylist: delayed 409 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Apr 2008 12:17:16 EDT
Message-Id: <200804041609.m34G9PPM003350@freevo.ajlc.waterloo.on.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Robin H. Johnson" <robbat2@gentoo.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: WARNING: at net/ipv4/tcp_input.c:2173
 tcp_mark_head_lost+0x173/0x1a0()
References: <20080402224137.GB25768@curie-int.orbis-terrarum.net>
	<20080403211913.3a0c1d00.akpm@linux-foundation.org>
From: Tony Lill <ajlill@ajlc.waterloo.on.ca>
Content-Type: text/plain; charset=US-ASCII
In-Reply-To: <20080403211913.3a0c1d00.akpm@linux-foundation.org> (Andrew
 Morton's message of "Thu, 3 Apr 2008 21:19:13 -0700")
User-Agent: Gnus/5.1002 (Gnus v5.10.2) XEmacs/21.4 (Constant Variable,
 linux)
MIME-Version: 1.0
Date: Fri, 04 Apr 2008 12:09:25 -0400
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> (cc netdev)
>
> (and Rafael - I assume 2.6.24 didn't do this..)
>
> On Wed, 2 Apr 2008 15:41:37 -0700 "Robin H. Johnson" <robbat2@gentoo.org> wrote:
>
>> (Please CC, not on LKML).
>> 
>> One of the nodes in my web-serving cluster (isohunt.com) started showing this:
>> 
>> ------------[ cut here ]------------
>> WARNING: at net/ipv4/tcp_input.c:2173 tcp_mark_head_lost+0x173/0x1a0()
>> Modules linked in: lm85 hwmon_vid nfs lockd nfs_acl sunrpc bonding reiserfs k8temp hwmon i2c_nforce2 i2c_core sg
>> Pid: 32500, comm: php-cgi Not tainted 2.6.25-rc4-git2 #7

Are you talking about the warning in this particular module, or
WARNINGS in tcp_input.c (and tcp_output.c) in general. 'Cause I've
been getting them sporadically since moving from 2.6.23 to 2.6.24.
At least I think that's the timeframe.

Mar 28 23:42:40 matrix kernel: WARNING: at net/ipv4/tcp_output.c:1799 tcp_simple_retransmit()
Mar 29 01:03:32 matrix kernel: WARNING: at net/ipv4/tcp_input.c:2413 tcp_fastretrans_alert()
Mar 29 01:12:41 matrix kernel: WARNING: at net/ipv4/tcp_input.c:1675 tcp_enter_frto()
Mar 29 03:03:04 matrix kernel: WARNING: at net/ipv4/tcp_input.c:2960 tcp_process_frto()
Mar 29 03:03:04 matrix kernel: WARNING: at net/ipv4/tcp_input.c:2314 tcp_try_to_open()

No user visble effects, and no messages since.

-tony
