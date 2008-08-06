Return-Path: <linux-kernel-owner+w=401wt.eu-S1757987AbYHFTsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987AbYHFTsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 15:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757482AbYHFTru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 15:47:50 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:44213 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756903AbYHFTrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 15:47:49 -0400
Message-ID: <4899FFDF.8010806@keyaccess.nl>
Date: Wed, 06 Aug 2008 21:47:43 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: jmerkey@wolfmountaingroup.com, Geert Uytterhoeven <geert@linux-m68k.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
References: <17494.166.70.238.46.1217784156.squirrel@webmail.wolfmountaingroup.com> <200808060145.22321.nickpiggin@yahoo.com.au> <56575.166.70.238.45.1217950327.squirrel@webmail.wolfmountaingroup.com> <200808060238.56113.nickpiggin@yahoo.com.au>
In-Reply-To: <200808060238.56113.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05-08-08 18:38, Nick Piggin wrote:

> That's all well and good :). But it didn't exactly answer my
> question. My question was not what is the point of you writing these
> patches, but what is the point of merging it into the kernel (over
> the alternatives). It may seem like a trivial question, but it is one
> that must be answered in order to be considered to get merged.

Nick, please note there is/was some mis-communication between the two of 
you with respect to kgdb, the currently merged GNU debugger interface, 
and kdb, the SGI kernel debugger.

Merkey responded to you as if you asked about differences with KDB while 
what you did was ask about differences with KGDB. Both KDB and MDB are 
significantly different from KGDB at least in sofar that the latter is a 
remote debugger; it requires two machines. KDB and MDB are local.

This makes KDB and MDB more accesible for small time use at least. The 
other most profound advantage is ofcourse that it's not GDB.

Rene.
