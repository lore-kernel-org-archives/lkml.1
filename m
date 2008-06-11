Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbYFKVF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbYFKVF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 17:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbYFKVFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 17:05:17 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:38254 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbYFKVFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 17:05:15 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <48503DCB.7050104@s5r6.in-berlin.de>
Date: Wed, 11 Jun 2008 23:04:11 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: chris2553@googlemail.com
CC: Greg KH <greg@kroah.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       Hannes Reinecke <hare@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-usb@vger.kernel.org
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
References: <200806010415.05290.chris2553@googlemail.com> <200806111858.05114.chris2553@googlemail.com> <20080611191533.GA6189@kroah.com> <200806111951.09275.chris2553@googlemail.com>
In-Reply-To: <200806111951.09275.chris2553@googlemail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Clayton wrote:
> On Wednesday 11 June 2008, Greg KH wrote:
>> Try commenting out the rule that does this and see if things are fixed.
> 
> Yes, that's it. It's this rule, which appears as the second rule in the 
> slackware rules file that's distributed with udev (and it's been there since 
> udev-97 in August 2006):
> 
> ACTION=="add", SUBSYSTEM=="scsi", WAIT_FOR_SYSFS="ioerr_cnt"
> 
> Commenting that rule out eliminates the pause in the boot and in the appearance 
> of icons on my desktop.

It's called a workaround, not a fix.
-- 
Stefan Richter
-=====-==--- -==- -=-==
http://arcgraph.de/sr/
