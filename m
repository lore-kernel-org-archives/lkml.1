Return-Path: <linux-kernel-owner+w=401wt.eu-S1757032AbZFYPx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032AbZFYPx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 11:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757939AbZFYPxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 11:53:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:15644 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757603AbZFYPxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 11:53:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,290,1243839600"; 
   d="scan'208";a="469559642"
Date: Thu, 25 Jun 2009 23:48:46 +0800
From: Alek Du <alek.du@intel.com>
To: Jani Nikula <ext-jani.1.nikula@nokia.com>
CC: LKML <linux-kernel@vger.kernel.org>, Trilok Soni <soni.trilok@gmail.com>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "ben-linux@fluff.org" <ben-linux@fluff.org>
Subject: Re: [PATCH]input: Change timer function to workqueue for gpio_keys
 driver
Message-ID: <20090625234846.1b987069@dxy.sh.intel.com>
In-Reply-To: <1245944528.20530.145.camel@jani-desktop>
References: <20090608152420.0e76c302@dxy.sh.intel.com>
	<5d5443650906121040n3f36c99eka01f5eb5274ee6ff@mail.gmail.com>
	<359ed6810906250329x70cf380cy278f23e3ebc6a829@mail.gmail.com>
	<20090625210642.432e08a5@dxy.sh.intel.com>
	<1245936693.20530.107.camel@jani-desktop>
	<20090625220826.1fa7413e@dxy.sh.intel.com>
	<1245941565.20530.134.camel@jani-desktop>
	<1245942355.20530.141.camel@jani-desktop>
	<20090625230949.53beda65@dxy.sh.intel.com>
	<1245944528.20530.145.camel@jani-desktop>
Organization: Intel Corp.
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jun 2009 23:42:08 +0800
Jani Nikula <ext-jani.1.nikula@nokia.com> wrote:

> On Thu, 2009-06-25 at 17:09 +0200, ext Alek Du wrote:
> > On Thu, 25 Jun 2009 23:05:55 +0800
> > Jani Nikula <ext-jani.1.nikula@nokia.com> wrote:
> > > Actually scrap that, the input layer already ignores events with no
> > > state changes, right?
> > > 
> > Yes, correct. I just want to reply your previous mail, but seems you find that. :-)
> 
> The point about your patch breaking debouncing is still valid, though.
> 
>
How? If IRQ triggered then the delay work scheduled, after debouncing time, in work, it checks GPIO pin state again,
if pin is active, send "1" to input layer -- key pressed, if de-active, send "0" -- no event. 

I really did test on my board, could you also try it out?

Thanks,
Alek
> BR,
> Jani.
> 
> 
