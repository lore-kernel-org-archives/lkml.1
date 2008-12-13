Return-Path: <linux-kernel-owner+w=401wt.eu-S1757357AbYLMLoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbYLMLoj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 06:44:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbYLMLo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 06:44:28 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:37732 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbYLMLo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 06:44:27 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49439FF9.50202@s5r6.in-berlin.de>
Date: Sat, 13 Dec 2008 12:43:53 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.18) Gecko/20081116 SeaMonkey/1.1.13
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: Pavel Machek <pavel@suse.cz>, smartmontools-support@lists.sourceforge.net,
       smartmontools-database-owner@lists.sourceforge.net,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, xfs@oss.sgi.com,
       Alan Piszcz <ap@solarrain.com>
Subject: Re: Intel X25-E running Linux using XFS
References: <alpine.DEB.1.10.0811271257470.2233@p34.internal.lan> <20081212185803.GE11974@elf.ucw.cz> <alpine.DEB.1.10.0812121516190.17857@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0812121516190.17857@p34.internal.lan>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> On Fri, 12 Dec 2008, Pavel Machek wrote:
>> Actually I'd like to know... how does it behave during powerfails
>> while it is being written to?
>>
>> Flashes I seen (USB / SD) developed bad sectors in that case, and
>> ext2/ext3 can't handle that. (And I don't think xfs can handle that
>> either).
> 
> I have a UPS for all of my machines, so that will not be a problem in my
> case.

UPSs fail too.

...
> With barriers, presumably it would be safe

There are other opinions:  http://lwn.net/Articles/309576/
(Magnetic disks are discussed there.)
-- 
Stefan Richter
-=====-==--- ==-- -==-=
http://arcgraph.de/sr/
