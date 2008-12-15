Return-Path: <linux-kernel-owner+w=401wt.eu-S1753761AbYLONwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbYLONwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 08:52:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbYLONwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 08:52:41 -0500
Received: from main.gmane.org ([80.91.229.2]:42816 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044AbYLONwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 08:52:40 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Holger Hoffstaette" <holger@wizards.de>
Subject: Re: 2.6.27 inotify causes unkillable processes with 100% CPU usage
Date: Mon, 15 Dec 2008 14:52:23 +0100
Organization: The Fists of the White Lotus
Message-ID: <pan.2008.12.15.13.52.23.253625@wizards.de>
References: <E459FC1E-BD45-459A-A9BD-AC682DBCD2D2@iki.fi> <20081215120512.GT28946@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: port-87-234-136-62.dynamic.qsc.de
User-Agent: Pan/0.13.91 (Before we let euphoria convince us we are free)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Dec 2008 12:05:12 +0000, Al Viro wrote:

> On Mon, Dec 15, 2008 at 01:31:29PM +0200, Timo Sirainen wrote:
>> There appears to be a bug in 2.6.27 and inotify where it causes
>> processes in running state to eat 100% CPU and they can't be killed with
>> kill -9, requiring a reboot to get rid of them.
> 
>> Kernels causing the hang:
>>
>> 2.6.27-9.slh.1-sidux-686
>> Arch Linux, kernel 2.6.27.8
>> Gentoo with 2.6.27-gentoo-r5, amd64, 2 dual core opterons
>>
>> Not causing the hang:
>>
>> 2.6.26-6.slh.1-sidux-686
> 
> Could you try to bisect that?  Particulary interesting commits:

Please see this posting, which also contains a pointer to the
necessary patch:
http://lkml.indiana.edu/hypermail/linux/kernel/0812.1/02305.html

According to GregKH it will be in -stable.10, but in the meantime you can
also apply the  patch from http://tinyurl.com/5gpqkj on top stable .8
(which introduced the regression) or .9.

At this point it is not clear whether the changes to inotify caused this
or just fell victim to the parallel regression in idr.

-h


