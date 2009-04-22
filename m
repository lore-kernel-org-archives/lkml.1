Return-Path: <linux-kernel-owner+w=401wt.eu-S1753502AbZDVDAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbZDVDAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 23:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbZDVDAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 23:00:06 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:52867 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbZDVDAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 23:00:04 -0400
Message-ID: <49EE8855.1080306@oracle.com>
Date: Tue, 21 Apr 2009 20:00:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: Kumar Gala <galak@kernel.crashing.org>, subrata@linux.vnet.ibm.com,
       linux-usb@vger.kernel.org, Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next <linux-next@vger.kernel.org>,
       sachinp <sachinp@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>, samr <sam@ravnborg.org>
Subject: Re: [BUILD FAILURE 11/12] Next April 21 : PPC64 randconfig [drivers/usb/host/ohci-hcd.o]
References: <1240340081.9110.144.camel@subratamodak.linux.ibm.com> <5A202317-5104-4784-845B-B8C46E0A3C48@kernel.crashing.org> <49EE4341.50701@oracle.com> <200904211919.38104.david-b@pacbell.net>
In-Reply-To: <200904211919.38104.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010201.49EE881D.003F:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> On Tuesday 21 April 2009, Randy Dunlap wrote:
>>> Since its feasible to say 'n' to both we get the compile error.  How do
>>> we enforce having at least one set?
>> Looks like using "choice" without "optional" would do it.
>> See Documentation/kbuild/kconfig-language.txt and various examples
>> in Kconfig* files.
> 
> That won't quite work ... "at least one" includes "two"
> (i.e. a PCI card in little-endian, a native controller
> in big-endian).  Real-world systems need such configs,
> or so I'm told, and that's why their supported.

Yes, I see.

> Is there maybe a way to force Kconfig to just reject
> such illegal configs -- neither option set -- rather
> than trying some how to fix it?

Not that I know of.  cc-ing Sam.

> Or maybe ... if neither one is set, have the header
> force both on, and issue a warning.

That should be doable.  We'd prefer to catch it via Kconfig,
but that doesn't look promising just now.

-- 
~Randy
