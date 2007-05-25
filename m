Return-Path: <linux-kernel-owner+w=401wt.eu-S1760198AbXEYIUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760198AbXEYIUP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 04:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752803AbXEYIT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 04:19:57 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:36960 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbXEYITz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 04:19:55 -0400
Message-ID: <46569C29.2050306@s5r6.in-berlin.de>
Date: Fri, 25 May 2007 10:19:53 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ismail_D=F6nmez?= <ismail@pardus.org.tr>
CC: Diego Calleja <diegocg@gmail.com>, Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       video4linux-list@redhat.com
Subject: Re: [PATCH 1/1] V4L: stk11xx, add a new webcam driver
References: <2172422218943432279@wsc.cz> <20070524193805.1b5d37d9.diegocg@gmail.com> <200705242101.03537.ismail@pardus.org.tr>
In-Reply-To: <200705242101.03537.ismail@pardus.org.tr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ismail Dönmez wrote:
> On Thursday 24 May 2007 20:38:05 Diego Calleja wrote:
>> El Thu, 24 May 2007 16:01:33 +0200 (CEST), Jiri Slaby <jirislaby@gmail.com> 
> escribió:
>> > +config USB_STK11XX
>> > +	tristate "STK11XX based webcams"
>> > +	depends on VIDEO_V4L2
>> > +	---help---
>> > +	  This will add support for Syntek webcams such as dc1125 and stk1135.
>> > +
>> > +	  If you choose to build it as module, it will be called stk11xx.
>>
>> Maybe this is a too picky requeriment, but IMO it would be nice if the
>> module would be called "camera_stk11xx", or had any other prefix that gives
>> some meaning about what is doing. It's hard to decipher from the name when
>> you run lsmod.
> 
> That would be too picky indeed since other camera modules have no camera_ 
> prefix like pwc,spca5xx, etc.

Then how about adding that prefix to all of them and provide the current
name as module alias?

Or at least, why not use better names for new modules?
-- 
Stefan Richter
-=====-=-=== -=-= ==--=
http://arcgraph.de/sr/
