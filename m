Return-Path: <linux-kernel-owner+w=401wt.eu-S1757944AbYAFOKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944AbYAFOKq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:10:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753925AbYAFOKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:10:38 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:49928 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbYAFOKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:10:37 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4780E0F7.100@s5r6.in-berlin.de>
Date: Sun, 06 Jan 2008 15:08:55 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: david@lang.hm
CC: Adrian Bunk <bunk@kernel.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Sam Ravnborg <sam@ravnborg.org>, Al Boldi <a1426z@gawab.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] USB Kconfig: Select SCSI for USB Mass Storage	support
References: <200801051546.SAA08947@raad.intranet> <20080105113024.209485f5.randy.dunlap@oracle.com> <20080105210330.GC22232@does.not.exist> <20080105210940.GA10302@uranus.ravnborg.org> <47801126.7020807@oracle.com> <20080105234540.GG22232@does.not.exist> <47802249.9010107@s5r6.in-berlin.de> <20080106005807.GH22232@does.not.exist> <4780C728.1030806@s5r6.in-berlin.de> <20080106123728.GD2082@does.not.exist> <4780D3E5.20908@s5r6.in-berlin.de> <Pine.LNX.4.64.0801060643370.16883@asgard.lang.hm> <4780DA92.6050403@s5r6.in-berlin.de> <Pine.LNX.4.64.0801060652390.16883@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0801060652390.16883@asgard.lang.hm>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> On Sun, 6 Jan 2008, Stefan Richter wrote:
>> build-time configuration has to deal with different, more
>> complex questions than run-time configuration.
...
> what config options must be selected by the user at build time? (i.e. no
> sane default can possibly be deduced from the hardware)
> 
> there are a lot of options that, if selected, will affect the final
> result significantly. but I can't think of any that can't have a
> reasonable default.
...

I agree that sets of defaults, e.g. based on usage profiles, help a lot.

Alas the 'select' keyword enforces one particular profile.  (And it is
currently broken and generally dangerous and inefficient for
dependencies deeper than one level.)
-- 
Stefan Richter
-=====-==--- ---= --==-
http://arcgraph.de/sr/
