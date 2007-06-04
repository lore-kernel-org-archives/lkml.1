Return-Path: <linux-kernel-owner+w=401wt.eu-S1758357AbXFDVvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758357AbXFDVvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 17:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754374AbXFDVvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 17:51:15 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:17973 "EHLO
	outbound6-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754191AbXFDVvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 17:51:14 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Message-ID: <466488C6.3070100@am.sony.com>
Date: Mon, 04 Jun 2007 14:48:54 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060614)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Problem with http URL for stable git tree?
References: <46646389.7090101@am.sony.com> <20070604211359.GA2046@kroah.com>
In-Reply-To: <20070604211359.GA2046@kroah.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Jun 2007 21:47:19.0815 (UTC) FILETIME=[ED136970:01C7A6F1]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Mon, Jun 04, 2007 at 12:10:01PM -0700, Tim Bird wrote:
>> Greg,
>>
>> I'm having problems cloning the stable git tree for 2.6.21.
>> Here's what I get:
>>
>> $ git clone http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.21.y.git stable-2.6.21.y
>> Cannot get remote repository information.
>> Perhaps git-update-server-info needs to be run there?
> 
> Ick, don't clone by "http://", please use the git protocol instead:
> 	git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.21.y.git
> 
> that should work better.

I'm behind a firewall that doesn't allow it.  Luckily, the
firewall has some holes to allow me ssh access to a few
external machines.  It looks like I can use a "git:" url on a
box outside the firewall, then clone that to inside Sony
with a "git+ssh:" url.

I'll do that, unless someone else has a better suggestion.
Pushes and pulls will be two steps each, but at least it works.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

