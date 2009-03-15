Return-Path: <linux-kernel-owner+w=401wt.eu-S1759553AbZCOULm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759553AbZCOULm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 16:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756649AbZCOULb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 16:11:31 -0400
Received: from kotten8a.marieberg.ac ([213.238.238.22]:40912 "HELO
	iluvatar.nyren.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754719AbZCOULa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 16:11:30 -0400
Date: Sun, 15 Mar 2009 21:11:22 +0100 (CET)
From: Ralf Nyren <ralf@nyren.net>
X-X-Sender: plumbum@fujje.iml.umu.se
To: Stephen Clark <sclark46@earthlink.net>
cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       klloyd@sierrawireless.com, rfiler@sierrawireless.com
Subject: Re: Sierra Wireless (MC8780) HSDPA speed issue
In-Reply-To: <49BC5A90.7070004@earthlink.net>
Message-ID: <alpine.DEB.1.10.0903152040030.5825@fujje.iml.umu.se>
References: <alpine.DEB.1.10.0903131551310.5791@fujje.iml.umu.se> <20090314040322.GB3417@kroah.com> <alpine.DEB.1.10.0903142021580.5797@fujje.iml.umu.se> <20090314203256.GA7487@kroah.com> <49BC5A90.7070004@earthlink.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Mar 2009, Stephen Clark wrote:
>
> Yes, it would be interesting to know how you determined the download speed?
>

Not very scientific but I first turned off all network apps and verified there
were no network traffic (eg tcpdump). Then I just downloaded a 10MB file of
random data a couple of times and took note of the average speed. Of course
average is not same as peek but hope it is good enough for a real world test.

Just to make sure I repeated the tests and the download speed in Linux was
slightly above 100KB/s average for the handful of download tests performed.
Downloading the same file in Windows a couple of times resulted in a download
average of 250-350KB/s, got different speeds for each test but this is likely
due to other UEs in the cell.

So Linux was at least 2.5 times slower in the download tests so somewhere
there has to be a problem.

I'm using pppd from Debian Lenny and just the standard set of AT commands.

Please let me know if you have any other suggestions for things to try.

Best regards, Ralf

