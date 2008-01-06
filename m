Return-Path: <linux-kernel-owner+w=401wt.eu-S1758333AbYAFN7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758333AbYAFN7m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 08:59:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755036AbYAFN7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 08:59:33 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:49542 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706AbYAFN7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 08:59:32 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4780DE52.1090402@s5r6.in-berlin.de>
Date: Sun, 06 Jan 2008 14:57:38 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>, Sam Ravnborg <sam@ravnborg.org>,
       Al Boldi <a1426z@gawab.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] USB Kconfig: Select SCSI for USB Mass Storage	support
References: <20080105113024.209485f5.randy.dunlap@oracle.com> <20080105210330.GC22232@does.not.exist> <20080105210940.GA10302@uranus.ravnborg.org> <47801126.7020807@oracle.com> <20080105234540.GG22232@does.not.exist> <47802249.9010107@s5r6.in-berlin.de> <20080106005807.GH22232@does.not.exist> <4780C728.1030806@s5r6.in-berlin.de> <20080106123728.GD2082@does.not.exist> <4780D3E5.20908@s5r6.in-berlin.de> <20080106133854.GH2082@does.not.exist>
In-Reply-To: <20080106133854.GH2082@does.not.exist>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Sun, Jan 06, 2008 at 02:13:09PM +0100, Stefan Richter wrote:
>> Module autoloading is quite different.
> 
> Both are "hardware -> required kernel support" mappings.
> 
> I know that people don't like this idea since the CML2 discussions, but 
> there even don't seem to be any big problems if anyone wants to put all 
> the pieces together and assemble a suitable .config only based on the 
> autodetection tools of some distribution and without asking the user 
> any questions.

How to autodetect that the user is going to buy gadget xyz next week?
(OK, he can re-run autodetection then, although that's not a
particularly economic strategy.)

How to autodetect POSIX_MQUEUE, HZ_250, HOTPLUG_PCI, ...?

[...]
>> This /is/ what we are currently doing, not "worse than what we are
>> currently doing".  We
>>   - sensibly modularize our software,
>>   - tell the user which software components there are,
>>   - what they are for,
>>   - how they depend on each other,
>>   - make it easy enough for the user to navigate in the dependency
>>     graph,
>>   - provide fundamental safeguards and checks for a proper software
>>     configuration.  (Well, we actually walk on thin ice whenever we
>>     use the 'select' keyword.)
>> ...
> 
> You miss the fundamental point:
> 
> The vast majority of kconfig users are _not_ kernel hackers, and they 
> neither know nor want to know anything about kernel internals - they 
> just want to build a kernel suitable for their system.

I don't miss the point.  I just say what we realistically can do.  And I
might add, we should try hard to achieve good results in each of the
points I listed.

> You want to make an UI easier to use for the developers but harder to 
> use for the users, and that's a bad deal.

No, I don't.

(I have "worked" long enough in enduser support, and still am doing
support, to not have completely lost an eye for enduser needs.  Or so I
believe.)
-- 
Stefan Richter
-=====-==--- ---= --==-
http://arcgraph.de/sr/
