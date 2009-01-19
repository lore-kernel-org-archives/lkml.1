Return-Path: <linux-kernel-owner+w=401wt.eu-S1757661AbZASSq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661AbZASSq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 13:46:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757581AbZASSpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 13:45:53 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:59299 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757563AbZASSpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 13:45:52 -0500
Message-ID: <4974CA81.1050506@ru.mvista.com>
Date: Mon, 19 Jan 2009 21:46:25 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] ide: move SFF I/O code to ide-io-sff.c
References: <20090119130309.24745.40877.sendpatchset@localhost.localdomain>	<20090119130322.24745.76137.sendpatchset@localhost.localdomain>	<49748B95.9080105@ru.mvista.com>	<200901191523.15240.bzolnier@gmail.com>	<49748E43.4030009@ru.mvista.com>	<20090119173701.13fd24c6@lxorguk.ukuu.org.uk>	<4974C030.5020509@ru.mvista.com> <20090119183607.5ee804e1@lxorguk.ukuu.org.uk>
In-Reply-To: <20090119183607.5ee804e1@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:

>>>BTW if you moved to ioreadX you could get rid of almost all the readb/inb
>>>special casing.

>>    And burden the driver code with function calls ISO in/out instructions, at 
>>least on x86. It's somewhat arguable move.

> And exactly how do you think the IDE accessors in the file get called ?

    Tried looking at how in*()/out*() are defined on x86?

> It's already making function calls, without the benefit of inlining and

    I'm afraid you're wrong here.

MBR, Sergei
