Return-Path: <linux-kernel-owner+w=401wt.eu-S1757593AbYLLMUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593AbYLLMUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 07:20:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756031AbYLLMU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 07:20:29 -0500
Received: from enyo.dsw2k3.info ([195.71.86.239]:52019 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755589AbYLLMU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 07:20:28 -0500
X-Greylist: delayed 1622 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Dec 2008 07:20:28 EST
Date: Fri, 12 Dec 2008 12:53:11 +0100
From: Matthias Schniedermeyer <ms@citd.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "J.A. Magallon" <magallon@unizar.es>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Is there something like multi-device fan out ?
Message-ID: <20081212115311.GA15948@citd.de>
References: <20081212000452.0ff5dfd9@werewolf.home> <4941A517.2010704@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4941A517.2010704@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.12.2008 15:41, H. Peter Anvin wrote:
> J.A. Magallon wrote:
> > Hi...
> > 
> > I suspect this sounds like a strange question.
> > A friend has a company that distributes his own catalogs on CD-ROM, and wants
> > to build a mass-burning box (something like 8 CD/DVD burners), running linux.
> > 
> > The problem is how to burn an image at the same time to all writers.
> > I could write a script, but I think this would launch 8 reads on the same
> > iso file, all desynchronized, that will drive nuts the disk.
> 
> Not really.  They will end up synchronized through a mechanism called
> the cache capture effect: the image that is behind will have the benefit
> of having the precursors already having read the input, so it's ready
> for use in the cache already, therefore it will run faster.  The stable
> condition, as long as the writers are close to the same speed and the
> writes are started at close enough to the the same time, is that they
> are all writing the same data at almost the same time.

And if you want to be absolutly sure.

RAM is cheap nowadays, plug in enough RAM (no swap!) so you can copy the 
image to burn into a tmpfs before starting to write them.
No disc IO involved at all. ;-)

A Single-layer DVD has a maximum of around 4.4GB so if you plugging in 
8GB, you are on the safe side.

Only for a Dual-Layer DVD you would need more RAM.




Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

