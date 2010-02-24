Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab0BXIXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 03:23:37 -0500
Received: from plane.gmane.org ([80.91.229.3]:37304 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416Ab0BXIXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 03:23:36 -0500
X-Greylist: delayed 2444 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Feb 2010 03:23:36 EST
X-SpamScore: -34
X-BigFish: VS-34(z21eWz1432R98dN936eMzz1202hzzz31j87h6bh43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
Message-ID: <4B84D2EA.4090209@krogh.cc>
Date: Wed, 24 Feb 2010 08:19:06 +0100
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "J. Bruce Fields" 
	<public-bfields-uC3wQj2KruNg9hUCZPvPmw@plane.gmane.org>
CC: Nikola Ciprich 
	<public-extmaillist-Jp3n8lUXroTtwjQa/ONI9g@plane.gmane.org>,
       Harry Edmon 
	<public-harry-qmPYOCrcNLLyFCzt5hm0YvZ8FUJU4vz8@plane.gmane.org>,
       Andrew Morton 
	<public-akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@plane.gmane.org>,
       public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org,
       public-linux-nfs-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org,
       public-nikola.ciprich-Jp3n8lUXroTtwjQa/ONI9g@plane.gmane.org
Subject: Re: 2.6.32.2 - WARNING: at lib/kref.c:43 kref_get+0x,23/0x2b()
References: <4B4F5A00.4060604@atmos.washington.edu> <20100122150325.6ad12428.akpm@linux-foundation.org> <20100127190522.GB18278@fieldses.org> <4B60C5D4.6070000@atmos.washington.edu> <20100202162228.GD4293@fieldses.org> <20100216182248.GA4922@nik-comp.linuxbox.cz> <20100216202121.GE26292@fieldses.org> <20100216202720.GB4922@nik-comp.linuxbox.cz> <20100216202947.GF26292@fieldses.org> <20100217151435.GC30897@develbox.linuxbox.cz> <20100220235105.GB15015@fieldses.org>
In-Reply-To: <20100220235105.GB15015@fieldses.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Reverse-DNS: unknown
X-TMDA-Confirmed: Wed, 24 Feb 2010 08:42:40 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




J. Bruce Fields wrote:
> On Wed, Feb 17, 2010 at 04:14:35PM +0100, Nikola Ciprich wrote:
>> Well,
>> I did a lot of stress tests, and it seems to be pretty random, and what's
>> worse, I think it is more then one problem, oh great...
>> Seems that at least one of my NFS problems was in fact caused by ext4 regression
>> (what FS are you using?)
>> applying this one: http://bugzilla.kernel.org/attachment.cgi?id=24975
>> improved things for me a lot (see http://bugzilla.kernel.org/show_bug.cgi?id=15231 for
>> full discussion).
>> I'll watch the machine for next few days and report...
> 
> Is there *any* kernel (however old) on which you are confident you can
> *not* reproduce the kref bug?

I have got a bug that looks a lot like this on 2.6.32.8 yesterday less 
than 24 hours after booting the first 2.6.32 kernel but we have been 
running on 2.6.31 for 3 months before, so I'm fairly confident that it 
is a .31 -> .32 regression.

http://lkml.org/lkml/2010/2/23/70

Jesper
-- 
Jesper



