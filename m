Return-Path: <linux-kernel-owner+w=401wt.eu-S1752987AbYLHIHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbYLHIHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 03:07:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbYLHIHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 03:07:41 -0500
Received: from main.gmane.org ([80.91.229.2]:51671 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbYLHIHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 03:07:41 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Holger Hoffstaette" <holger@wizards.de>
Subject: Re: Nasty regression from .27.7 to .27.8: idle samba goes crazy
Date: Mon, 08 Dec 2008 09:07:29 +0100
Organization: The Fists of the White Lotus
Message-ID: <pan.2008.12.08.08.07.29.439625@wizards.de>
References: <pan.2008.12.08.06.18.57.357875@wizards.de> <200812080834.22924.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: port-87-234-136-62.dynamic.qsc.de
User-Agent: Pan/0.13.91 (Before we let euphoria convince us we are free)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Dec 2008 08:34:22 +0100, Rafael J. Wysocki wrote:

> On Monday, 8 of December 2008, Holger Hoffstaette wrote:
>> 
>> A while after disconnecting a samba client, the smbd samba server
>> process goes crazy and consumes 100% CPU. From that time on it is
>> unkillable (kill -9 returns but the process continues to run). The only
>> recourse is reboot, which works without problem (i.e. unmounting the
>> served filesystems is apparently possible?). I tried to attach to the
>> process with gdb but that just hung.
>> [..]
> 
> Please bisect.

I would love to try, but this is my "production server" (i.e. I need it
for real work) and I'll be traveling the next few days. I will try to
bisect after that (if nobody else has any ideas) but will have to make
sure the bug is actually reproducible after the timeout - for now I only
observed it by accident (via mrtg).
In the meantime maybe someone else will observe it as well.

thanks
Holger


