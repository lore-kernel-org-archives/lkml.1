Return-Path: <linux-kernel-owner+w=401wt.eu-S933209AbXF2Hyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933209AbXF2Hyc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 03:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764851AbXF2HyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 03:54:17 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:39649 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764641AbXF2HyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 03:54:15 -0400
Message-ID: <4684BAA4.4010905@dgreaves.com>
Date: Fri, 29 Jun 2007 08:54:12 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070618)
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       linux-pm <linux-pm@lists.osdl.org>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com, LinuxRaid <linux-raid@vger.kernel.org>,
       LVM general discussion and development 
	<linux-lvm@redhat.com>,
       David Robinson <zxvdr.au@gmail.com>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [linux-pm] Re: [linux-lvm] 2.6.22-rc4 XFS fails after hibernate/resume
References: <46744065.6060605@dgreaves.com> <200706281727.35430.rjw@sisk.pl> <20070628220045.GA4521@elf.ucw.cz> <200706290016.45719.rjw@sisk.pl> <20070629050024.GO31489@sgi.com> <4684B750.5030001@dgreaves.com> <20070629074322.GT31489@sgi.com>
In-Reply-To: <20070629074322.GT31489@sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:
> On Fri, Jun 29, 2007 at 08:40:00AM +0100, David Greaves wrote:
>> What happens if a filesystem is frozen and I hibernate?
>> Will it be thawed when I resume?
> 
> If you froze it yourself, then you'll have to thaw it yourself.

So hibernate will not attempt to re-freeze a frozen fs and, during resume, it 
will only thaw filesystems that were frozen by the suspend?

David

