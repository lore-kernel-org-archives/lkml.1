Return-Path: <linux-kernel-owner+w=401wt.eu-S1760255AbXEKLSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760255AbXEKLSk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 07:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757304AbXEKLSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 07:18:34 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:41454 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986AbXEKLSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 07:18:33 -0400
Message-ID: <464450CC.7010002@s5r6.in-berlin.de>
Date: Fri, 11 May 2007 13:17:32 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Heikki Orsila <shdl@zakalwe.fi>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Satyam Sharma <satyam.sharma@gmail.com>
Subject: Re: [PATCH] "volatile considered harmful", take 2
References: <6143.1178828419@lwn.net>
In-Reply-To: <6143.1178828419@lwn.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet wrote:
> +The key point to understand with regard to volatile is that its purpose is
> +to suppress optimization, which is almost never what one really wants to
> +do.  In the kernel, one must protect shared data structures against
> +unwanted concurrent access, which is very much a different task.  As it
> +happens, once the critical sections are properly implemented, the compiler
> +optimization issues which volatile was added to prevent will have been
> +taken care of in a more efficient way.

The "As it happens... efficient way." sentence is hard to read:  It is
long and nested like in German, combined with several English
ambiguities (e.g. WRT noun vs. verb vs. adjective).  Maybe just leave
this sentence out, as it is redundant to later statements like "In
properly-written kernel code, volatile can only serve to slow things down".
-- 
Stefan Richter
-=====-=-=== -=-= -=-==
http://arcgraph.de/sr/
