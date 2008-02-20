Return-Path: <linux-kernel-owner+w=401wt.eu-S1764010AbYBTSrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764010AbYBTSrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 13:47:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760834AbYBTSrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 13:47:22 -0500
Received: from rtr.ca ([76.10.145.34]:2647 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759460AbYBTSrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 13:47:20 -0500
Message-ID: <47BC75B6.7000509@rtr.ca>
Date: Wed, 20 Feb 2008 13:47:18 -0500
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Jesse Barnes <jesse.barnes@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@linux.ie>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Greg KH <gregkh@suse.de>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk.
 Screen becomes green.
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com>
In-Reply-To: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Chua wrote:
> 
> 
> On Feb 20, 2008 2:19 PM, Jeff Chua
>> I'll try the "idle=poll" to see if that works and will try some printk
> 
> I don't know what exactly the i915_suspend() and i915_resume() are 
> supposed to do because it works better without them.
> 
> After inserting "return 0;" right at the top of those two functions, 
> suspend (and power-off properly), and resume (without green screen) 
> works just fine.
..

Does this machine have more than one CPU core?  If so..
Does your kernel have CONFIG_HOTPLUG_CPU=y (if not, enable it).

??
