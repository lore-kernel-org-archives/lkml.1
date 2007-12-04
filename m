Return-Path: <linux-kernel-owner+w=401wt.eu-S1753937AbXLDWuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbXLDWuz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 17:50:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbXLDWur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 17:50:47 -0500
Received: from lazybastard.de ([212.112.238.170]:38376 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbXLDWur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 17:50:47 -0500
Date: Tue, 4 Dec 2007 23:45:25 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Jared Hulbert <jaredeh@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Chris Friesen <cfriesen@nortel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: solid state drive access and context switching
Message-ID: <20071204224525.GC26112@lazybastard.org>
References: <47548BF4.3010907@nortel.com> <20071203230629.725f4c7a@the-village.bc.nu> <6934efce0712040954v74cf0b4bk19b49988bc828233@mail.gmail.com> <20071204203536.2bf6d025@the-village.bc.nu> <6934efce0712041354n47c11d6ckbc7f4aa1e7c85f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6934efce0712041354n47c11d6ckbc7f4aa1e7c85f@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 December 2007 13:54:21 -0800, Jared Hulbert wrote:
> 
> Maybe I'm missing something but I don't see it.  We want a block
> interface for these devices, we just need a faster slimmer interface.
> Maybe a new mtdblock interface that doesn't do erase would be the
> place for?

Doesn't do erase?  MTD has to learn almost all tricks from the block
layer, as devices are becoming high-latency high-bandwidth, compared to
what MTD was designed for.  In order to get any decent performance, we
need asynchronous operations, request queues and caching.

The only useful advantage MTD does have over block devices is an
_explicit_ erase operation.  Did you mean "doesn't do _implicit_ erase".

Jörn

-- 
It's just what we asked for, but not what we want!
-- anonymous
