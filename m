Return-Path: <linux-kernel-owner+w=401wt.eu-S1758306AbZDGTao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758306AbZDGTao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 15:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755718AbZDGTaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 15:30:35 -0400
Received: from fmailhost04.isp.att.net ([204.127.217.104]:46977 "EHLO
	fmailhost04.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328AbZDGTae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 15:30:34 -0400
X-Originating-IP: [69.76.240.125]
Message-ID: <49DBA9D0.7080400@lwfinger.net>
Date: Tue, 07 Apr 2009 14:30:24 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [2 regressions] Current git cannot find root device on x86-64(HP
 nx6325), NFS broken
References: <49DB69FA.1060202@lwfinger.net> <200904072113.20703.rjw@sisk.pl>
In-Reply-To: <200904072113.20703.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Tuesday 07 April 2009, Larry Finger wrote:
>> My system also fails to load modules from initrd unless 9cb610d is reverted.
>> Something is wrong with the "module: remove the SHF_ALLOC flag on the __versions
>> section" patch.
> 
> This is fixed in the current -git, although I had to apply the patch from
> http://patchwork.kernel.org/patch/16776/
> to fix an Oops on boot.

Thanks for the heads-up, particularly on the 16776 patch above. I was in the
middle of a bisection to isolate that one.

Do you know anything about a regression that leads to "phy0: Failed to
initialize wep: -2" messages? It is the 3rd one that I'm chasing and seems to
affect all wireless drivers. For this one, removing and reinserting the driver
corrects the problem.

Larry



