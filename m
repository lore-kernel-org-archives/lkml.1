Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbYAFMVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbYAFMVG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 07:21:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbYAFMU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 07:20:56 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44754 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbYAFMUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 07:20:55 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4780C728.1030806@s5r6.in-berlin.de>
Date: Sun, 06 Jan 2008 13:18:48 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>, Sam Ravnborg <sam@ravnborg.org>,
       Al Boldi <a1426z@gawab.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] USB Kconfig: Select SCSI for USB Mass Storage	support
References: <200801051546.SAA08947@raad.intranet> <20080105113024.209485f5.randy.dunlap@oracle.com> <20080105210330.GC22232@does.not.exist> <20080105210940.GA10302@uranus.ravnborg.org> <47801126.7020807@oracle.com> <20080105234540.GG22232@does.not.exist> <47802249.9010107@s5r6.in-berlin.de> <20080106005807.GH22232@does.not.exist>
In-Reply-To: <20080106005807.GH22232@does.not.exist>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Sun, Jan 06, 2008 at 01:35:21AM +0100, Stefan Richter wrote:
>> Adrian Bunk wrote:
>>> Whether or not an option requires an additional subsystem like e.g. SCSI 
>>> or SSB are hardware and implementation details we shouldn't bother 
>>> kconfig users with.
>> What is an implementation detail and what is not?  In the end,
>> everything that we configure in Kconfig is implementation details.
> 
> With the use case "system administrator" we can expect people to know 
> the name of their ethernet card and which filesystems they use, but we 
> should not bother them with the fact that their network card might 
> require the Sonics Silicon Backplane support.

I'm afraid this can't be put into practice.  (User says which hardware
and protocols he needs to be supported, scripts magically assemble a
suitable configuration.)

I think
  - sensibly modularize our software,
  - tell the user which software components there are,
  - what they are for,
  - how they depend on each other,
  - make it easy enough for the user to navigate in the dependency
    graph,
  - provide fundamental safeguards and checks for a proper software
    configuration
is the best we can do.
-- 
Stefan Richter
-=====-==--- ---= --==-
http://arcgraph.de/sr/
