Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469AbYIYT6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbYIYT6g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 15:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbYIYT60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 15:58:26 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:33085 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752293AbYIYT6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 15:58:25 -0400
X-Sasl-enc: 6/XXm8NfEt6/Psb73PoYoHyzFyb1o2Iun3T8bOTiQsKe 1222372703
Date: Thu, 25 Sep 2008 16:58:20 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: carbonated beverage <ramune@net-ronin.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org
Subject: Re: CONFIG_ACPI_VIDEO on Thinkpad blanks display.
Message-ID: <20080925195820.GD30858@khazad-dum.debian.net>
References: <20080925060244.GA18945@net-ronin.org> <20080925070741.GA22376@net-ronin.org> <20080925100746.GA13185@srcf.ucam.org> <20080925190930.GA17184@net-ronin.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080925190930.GA17184@net-ronin.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2008, carbonated beverage wrote:
> On Thu, Sep 25, 2008 at 11:07:46AM +0100, Matthew Garrett wrote:
> > > Without CONFIG_ACPI_VIDEO, the above message don't appear.  From this point,
> > > any pointers on figuring out why the ACPI features makes the screen go blank?
> > 
> > Yes. X assumed that any ACPI key press was a request to switch the video 
> > output. Upgrade X.
> 
> Since CONFIG_ACPI_VIDEO wasn't required before 2.6.26.x to change the LCD
> brightness, I'd rather the kernel go back to whatever it was doing for

Well, we do give you a way out: do not load ACPI video, and load
thinkpad-acpi with the proper parameters to enable its backlight control (if
it is getting disabled by default).  Check the docs.

> 2.6.25.x.  Upgrading X past what's currently packaged by the distribution
> just to get a new kernel working is somewhat of a pain.

Your X is broken, and in an extremely hideous way.  You could try to get it
to disable ACPI key support, or you can make sure nothing EVER sends ACPI
video events to it.  That means you must not use the ACPI video module in
your kernel until you install a fixed X.org.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
