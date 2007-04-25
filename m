Return-Path: <linux-kernel-owner+w=401wt.eu-S1754089AbXDYPdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbXDYPdY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 11:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbXDYPdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 11:33:24 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:37667 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089AbXDYPdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 11:33:23 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17967.29851.680497.648681@smtp.charter.net>
Date: Wed, 25 Apr 2007 11:32:43 -0400
From: "John Stoffel" <john@stoffel.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: Serial console problem in 2.6.21-rc7-mm1 and earlier
In-Reply-To: <Pine.LNX.4.64.0704241421140.13904@schroedinger.engr.sgi.com>
References: <20070424130601.4ab89d54.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704241320540.13005@schroedinger.engr.sgi.com>
	<20070424132740.e4bdf391.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704241332090.13005@schroedinger.engr.sgi.com>
	<20070424134325.f71460af.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704241351400.13382@schroedinger.engr.sgi.com>
	<20070424141826.952d2d32.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704241421140.13904@schroedinger.engr.sgi.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Christoph> On Tue, 24 Apr 2007, Andrew Morton wrote:
>> > Nothing special apart from 
>> > the usual problem with serial not accepting characters that we had for 
>> > awhile now.
>> 
>> I wasn't aware of that one.

Christoph> I use a serial console on my x86_84 box. For a while now I
Christoph> can see all output but I cannot type any
Christoph> characters. /dev/console broke?

I've sorta seen this problem too, but with gdm.  If I have my kernel
line setup like this:

	... console=tty0 console=ttyS0,9600n8

I have to stop and restart gdm (or switch to the XDMCP chooser and
back) to get keyoard access.  Wierd. 

Christoph> Simple WAR is to ssh into the box and I was usually too
Christoph> focused on other issues to do something about it.

Are you trying to access an X login prompter, or just a plain Virtual
Console tty?

John
