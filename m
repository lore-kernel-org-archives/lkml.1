Return-Path: <linux-kernel-owner+w=401wt.eu-S1750930AbXDJTFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750930AbXDJTFE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 15:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753008AbXDJTFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 15:05:04 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:11919 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750930AbXDJTFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 15:05:02 -0400
Message-ID: <461BDFEA.8040602@cfl.rr.com>
Date: Tue, 10 Apr 2007 15:05:14 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>
CC: linux-kernel@vger.kernel.org, Olaf Hering <olaf@aepfle.de>,
       Dave Dillow <dave@thedillows.org>, Dave Jones <davej@redhat.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jeff@garzik.org>
Subject: Re: I give up
References: <200704091007.58535.gene.heskett@gmail.com> <1176169246.3193.2.camel@obelisk.thedillows.org> <20070410071217.GA28899@aepfle.de> <200704100353.14208.gene.heskett@gmail.com>
In-Reply-To: <200704100353.14208.gene.heskett@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Apr 2007 19:05:22.0260 (UTC) FILETIME=[303DF140:01C77BA3]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-15108.000
X-TM-AS-Result: No--6.702100-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> YOU Tell the tar people, they are flabbergasted that linux is apparently 
> the only unstable OS that tar can be run on.

How about cygwin/windows?  It has no concept of static device numbers. 
And what about external usb disks on any other unix os?  Surely they 
don't have static minor device numbers in the face of hot plugging?

The bug is in tar and that is what needs fixed.  It should not attach 
any meaning to the device number, but rather should assume that the 
admin knows what he is doing when he said to backup a given path using a 
given incremental backup log, and that he isn't yanking tar's chain and 
pointing it to a different path between incremental backups.


