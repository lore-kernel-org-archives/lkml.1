Return-Path: <linux-kernel-owner+w=401wt.eu-S1756960AbYFKWEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960AbYFKWEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 18:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbYFKWEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 18:04:06 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:38801 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbYFKWEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 18:04:04 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <48504B94.9050100@s5r6.in-berlin.de>
Date: Thu, 12 Jun 2008 00:03:00 +0200
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
References: <200806010415.05290.chris2553@googlemail.com> <200806111858.05114.chris2553@googlemail.com> <20080611191533.GA6189@kroah.com> <200806111951.09275.chris2553@googlemail.com> <485047C1.3020200@s5r6.in-berlin.de>
In-Reply-To: <485047C1.3020200@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> /etc/udev/rules.d/05-udev-early.rules:ACTION=="add", 
> KERNEL=="[0-9]*:[0-9]*", SUBSYSTEM=="scsi", WAIT_FOR_SYSFS="ioerr_cnt"
> 
> Whatever this rule is good for...  Maybe the pattern should be 
> "[0-9]+(:[0-9]+){3}" to match logical units only.

Actually no; looks like these are just glob(7) patterns.  Then the 
pattern might already be OK since host devices' and target devices' 
names don't start with decimal numbers.
-- 
Stefan Richter
-=====-==--- -==- -=-==
http://arcgraph.de/sr/
