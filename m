Return-Path: <linux-kernel-owner+w=401wt.eu-S1760587AbXEYJu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760587AbXEYJu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 05:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbXEYJuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 05:50:21 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:37265 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbXEYJuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 05:50:20 -0400
Message-ID: <4656B15A.6030006@s5r6.in-berlin.de>
Date: Fri, 25 May 2007 11:50:18 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: =?UTF-8?B?SXNtYWlsIETDtm5tZXo=?= <ismail@pardus.org.tr>,
       Diego Calleja <diegocg@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       video4linux-list@redhat.com
Subject: Re: [PATCH 1/1] V4L: stk11xx, add a new webcam driver
References: <2172422218943432279@wsc.cz>	 <20070524193805.1b5d37d9.diegocg@gmail.com>	 <200705242101.03537.ismail@pardus.org.tr>	 <46569C29.2050306@s5r6.in-berlin.de> <4af2d03a0705250127j3d05cd6bkb114cad0e6ecb449@mail.gmail.com>
In-Reply-To: <4af2d03a0705250127j3d05cd6bkb114cad0e6ecb449@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> On 5/25/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> Ismail Dönmez wrote:
>> > On Thursday 24 May 2007 20:38:05 Diego Calleja wrote:
>> >> Maybe this is a too picky requeriment, but IMO it would be nice if the
>> >> module would be called "camera_stk11xx", or had any other prefix that gives
>> >> some meaning about what is doing. It's hard to decipher from the name when
>> >> you run lsmod.
>> >
>> > That would be too picky indeed since other camera modules have no camera_
>> > prefix like pwc,spca5xx, etc.
>>
>> Then how about adding that prefix to all of them and provide the current
>> name as module alias?
>>
>> Or at least, why not use better names for new modules?
> 
> Just because modules can serve more that one interface of the device?
> (audio/mic, camera), (remote controller, dvb grabber). I didn't get
> the point of having the prefix in the name, what's the matter?

A prefix which describes the function of a driver is of course only
useful if it /correctly/ describes it.  What would be /correct/?  If a
driver for a audio + video capable camera supports either both audio and
video capture or only video capture, I don't see anything wrong with a
prefix like "camera".

That said, we have "modinfo" at our disposal if we spot something
nondescript in lsmod's listing.
-- 
Stefan Richter
-=====-=-=== -=-= ==--=
http://arcgraph.de/sr/
