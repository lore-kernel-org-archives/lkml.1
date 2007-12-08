Return-Path: <linux-kernel-owner+w=401wt.eu-S1752828AbXLHScS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbXLHScS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 13:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbXLHScH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 13:32:07 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:49027 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbXLHScG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 13:32:06 -0500
Message-ID: <475AE2ED.3050700@garzik.org>
Date: Sat, 08 Dec 2007 13:31:09 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Mike McGrath <mmcgrath@redhat.com>,
       Jon Masters <jonathan@jonmasters.org>, Matt Mackall <mpm@selenic.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ray Lee <ray@madrabbit.org>,
       Adrian Bunk <bunk@kernel.org>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
References: <20071204210827.GE19691@waste.org> <4755C423.60907@redhat.com> <20071204221525.GG19691@waste.org> <4755D350.1080801@redhat.com> <20071204223345.GJ19691@waste.org> <4756B50B.3060100@redhat.com> <20071205144934.GL7259@thunk.org> <1197099477.20786.149.camel@perihelion> <20071208173204.GI17037@thunk.org> <475AD585.7020908@redhat.com> <20071208174908.GJ17037@thunk.org>
In-Reply-To: <20071208174908.GJ17037@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Sat, Dec 08, 2007 at 11:33:57AM -0600, Mike McGrath wrote:
>>> Huh?  What's the concern?  All you are submitting is a list of
>>> hardware devices in your system.  That's hardly anything sensitive....
>> We actually had a very vocal minority about all of that which ended up 
>> putting us in the unfortunate position of generating a random UUID instead 
>> of using a hardware UUID from hal :-/
> 
> Tinfoil hat responses indeed!  Ok, if those folks are really that
> crazy, my suggestion then would be to do a "ifconfig -a > /dev/random"

heh, along those lines you could also do

	dmesg > /dev/random

<grin>

dmesg often has machine-unique identifiers of all sorts (including the 
MAC address, if you have an ethernet driver loaded)

	Jeff



