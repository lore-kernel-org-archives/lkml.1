Return-Path: <linux-kernel-owner+w=401wt.eu-S933979AbYB2WK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933979AbYB2WK3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 17:10:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761743AbYB2WKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 17:10:15 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:59595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751769AbYB2WKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 17:10:14 -0500
Date: Fri, 29 Feb 2008 14:08:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: johnstul@us.ibm.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       rostedt@goodmis.org
Subject: Re: [PATCH] Remove obsolete CLOCK_TICK_ADJUST
Message-Id: <20080229140842.575e72aa.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0802290547320.2723@scrub.home>
References: <1201142334.6383.40.camel@localhost.localdomain>
	<1201573686.6766.13.camel@localhost>
	<Pine.LNX.4.64.0801290439480.17507@scrub.home>
	<1201659263.6766.40.camel@localhost>
	<Pine.LNX.4.64.0801310251090.17507@scrub.home>
	<1201745776.6195.14.camel@localhost.localdomain>
	<Pine.LNX.4.64.0801310404480.17507@scrub.home>
	<1201914175.6216.46.camel@jstultz-laptop>
	<Pine.LNX.4.64.0802081718040.3378@scrub.home>
	<1202523452.6174.45.camel@localhost.localdomain>
	<Pine.LNX.4.64.0802101917030.3378@scrub.home>
	<1202774999.5984.106.camel@localhost>
	<Pine.LNX.4.64.0802120335170.3378@scrub.home>
	<1202963796.6195.141.camel@localhost.localdomain>
	<Pine.LNX.4.64.0802150436300.1822@scrub.home>
	<1203382940.5984.242.camel@localhost>
	<Pine.LNX.4.64.0802190219360.2723@scrub.home>
	<1203472250.6123.98.camel@localhost>
	<Pine.LNX.4.64.0802200348230.2723@scrub.home>
	<1203647951.6150.80.camel@localhost.localdomain>
	<Pine.LNX.4.64.0802290547320.2723@scrub.home>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Feb 2008 05:49:35 +0100 (CET)
Roman Zippel <zippel@linux-m68k.org> wrote:

> Can we please clean up the current mess and get the patch below merged?
> 
> bye, Roman
> 
> 
> Revert bbe4d18ac2e058c56adb0cd71f49d9ed3216a405 and
> e13a2e61dd5152f5499d2003470acf9c838eab84 and remove CLOCK_TICK_ADJUST
> completely. Add a optional kernel parameter ntp_tick_adj instead to allow
> adjusting of a large base drift and thus keeping ntpd happy.
> The CLOCK_TICK_ADJUST mechanism was introduced at a time PIT was the
> primary clock, but we have a varity of clock sources now, so a global PIT
> specific adjustment makes little sense anymore.
> 

The changelog provides no reason for the revert of those two patches.

Look at it from the point of view of a person who hasn't been following the
discussion (whose initials might be LT).  That person might get puzzled and
upset, no?

