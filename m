Return-Path: <linux-kernel-owner+w=401wt.eu-S637787AbXDSOta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S637787AbXDSOta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 10:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S637790AbXDSOta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 10:49:30 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:61016 "EHLO
	outbound1-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S637787AbXDSOt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 10:49:29 -0400
X-BigFish: VP
X-FB-SS: 0
X-Server-Uuid: 89466532-923C-4A88-82C1-66ACAA0041DF
Date: Thu, 19 Apr 2007 08:27:46 -0600
From: "Jordan Crouse" <jordan.crouse@amd.com>
To: "Jean Delvare" <khali@linux-fr.org>
cc: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "David Brownell" <david-b@pacbell.net>,
       "Bryan Wu" <bryan.wu@analog.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Deepak Saxena" <dsaxena@plexity.net>, linux-kernel@vger.kernel.org,
       "Christer Weinigel" <wingel@nano-system.com>
Subject: Re: Bitbanging i2c bus driver using the GPIO API
Message-ID: <20070419142746.GF11323@cosmic.amd.com>
References: <11765554074106-git-send-email-hskinnemoen@atmel.com>
 <20070414163418.20490fe2@dhcp-252-105.norway.atmel.com>
 <20070414192807.60bdf84b@hyperion.delvare>
 <20070418174256.GB5577@csclub.uwaterloo.ca>
 <20070419085413.1520feef@hyperion.delvare>
MIME-Version: 1.0
In-Reply-To: <20070419085413.1520feef@hyperion.delvare>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 19 Apr 2007 14:27:38.0097 (UTC)
 FILETIME=[E1583610:01C7828E]
X-WSS-ID: 6A39A3D02EG5748960-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/04/07 08:54 +0200, Jean Delvare wrote:
> Hi Len,
> 
> On Wed, 18 Apr 2007 13:42:56 -0400, Lennart Sorensen wrote:
> > On Sat, Apr 14, 2007 at 07:28:07PM +0200, Jean Delvare wrote:
> > > Otherwise it looks OK to me, I take the patch. If others have comments
> > > or objections, just speak up and submit incremental patches as needed.
> > > 
> > > Now I would like to see platform code actually using this.
> > 
> > Any idea how similar this new driver is to the scx200_i2c driver?  As
> > far as I can tell that driver is already a bit banged i2c over gpio
> > lines.
> 
> The major difference is that the implementation in scx200_i2c is
> hardware-specific, while the i2c-gpio driver is a generic one, so it's
> a lot better.
> 
> What this means is that i2c-gpio obsoletes scx200_i2c, so I am inclined
> to delete scx200_i2c right away. I'm not even sure anyone still uses it
> now that scx200_acb has been fixed and is reported to work very well.
> If anyone really needs to do I2C over GPIO pins on SCx200, this should
> be reimplemented on top of i2c-gpio.

It would also force us to move the Geode GPIO pins to the generic 
infrastructure, so that would be good.  I say delete it - if anybody needs
that functionality, then we'll do it the right way.

Jordan


