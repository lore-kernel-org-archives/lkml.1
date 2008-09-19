Return-Path: <linux-kernel-owner+w=401wt.eu-S1755601AbYISTW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbYISTW4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 15:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907AbYISTWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 15:22:47 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:62843 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbYISTWq (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 15:22:46 -0400
Date: Fri, 19 Sep 2008 12:20:38 -0700 (PDT)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: Jared Hulbert <jaredeh@gmail.com>
cc: Jamie Lokier <jamie@shareable.org>, cotte@de.ibm.com,
       Greg Ungerer <gerg@snapgear.com>, linux-embedded@vger.kernel.org,
       nickpiggin@yahoo.com.au, =?UTF-8?Q?J=C3=B6rn_Engel?= <joern@logfs.org>,
       Linux-kernel@vger.kernel.org, linux-mtd <linux-mtd@lists.infradead.org>,
       tim.bird@am.sony.com
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
In-Reply-To: <6934efce0809151243h60a6e48bpf0c7600d4badf3c4@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0809191216450.3476@t2.domain.actdsltmp>
References: <6934efce0809121452kd20deb6m268715f6ed83a71e@mail.gmail.com>
 <20080915163421.GA13631@shareable.org> <6934efce0809151243h60a6e48bpf0c7600d4badf3c4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Sep 2008, Jared Hulbert wrote:
>>>>> I'm using Spansion MirrorBit S29GL128N, which reads at about 0.6 MByte/s.
>>>
>>> If you are using a GL, you'll probably find our P33 a good fit and at
>>> competitive prices to GL as I understand it.  That's I think 50Mhz.
>>
>> What's a GL?  Never heard of it - all I can think of is OpenGL :-)
>
> S29_GL_128N

I'm using a S29GL064N chip.  Going through linux and /dev/mtd I get 13.5
MB/sec and reading directly from the chips give 15 MB/sec.  I've not mapped
the chip cached and I'm not using the page burst mode.  That would help a lot
certainly, but the current flash speed isn't much of a bottleneck.
