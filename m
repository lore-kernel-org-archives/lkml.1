Return-Path: <linux-kernel-owner+w=401wt.eu-S934581AbXLOBkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934581AbXLOBkG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 20:40:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754955AbXLOBjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 20:39:54 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754851AbXLOBjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 20:39:51 -0500
Message-ID: <47633028.20503@redhat.com>
Date: Fri, 14 Dec 2007 20:38:48 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.23.10
References: <20071214194952.GA15765@kroah.com> <476326BE.3080002@redhat.com> <200712150252.57427.rjw@sisk.pl>
In-Reply-To: <200712150252.57427.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2007 08:52 PM, Rafael J. Wysocki wrote:
> On Saturday, 15 of December 2007, Chuck Ebbert wrote:
>> On 12/14/2007 02:49 PM, Greg Kroah-Hartman wrote:
>>>       Freezer: Fix APM emulation breakage
>> drivers/char/apm-emulation.c: In function 'apm_ioctl':
>> drivers/char/apm-emulation.c:370: error: implicit declaration of function 'wait_event_freezable'
>> make[2]: *** [drivers/char/apm-emulation.o] Error 1
>> make[1]: *** [drivers/char] Error 2
> 
> This is my fault, sorry.
> 
> I though the 2.6.24-rc fix would be suitable for 2.6.23.x, but that's not the
> case.
> 
> Greg, please revert the "Freezer: Fix APM emulation breakage" patch, I'll
> prepare a separate fix suitable for -stable.
> 

It works if you add the changes to freezer.h made in commit
e42837bcd35b75bb59ae5d3e62f87be1aeeb05c3

