Return-Path: <linux-kernel-owner+w=401wt.eu-S1765031AbYEFPu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765031AbYEFPu7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 11:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759252AbYEFPuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 11:50:52 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:58060 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbYEFPuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 11:50:51 -0400
Message-ID: <48207E90.9000202@keyaccess.nl>
Date: Tue, 06 May 2008 17:51:44 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Pete Clements <clem@clem.clem-digital.net>
CC: Takashi Iwai <tiwai@suse.de>, linux-kernel <linux-kernel@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: Lost Sound from 2.6.24 to 2.6.25 -- CS4236 ISA
References: <200805061538.m46FcgZ3002921@clem.clem-digital.net>
In-Reply-To: <200805061538.m46FcgZ3002921@clem.clem-digital.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06-05-08 17:38, Pete Clements wrote:

> Quoting Takashi Iwai
>   > At Mon, 5 May 2008 10:06:51 -0400 (EDT),
>   > Pete Clements wrote:
>   > > 
>   > > Looks like sound card stops functioning between
>   > > 2.6.24 and 2.6.25.
>   > 
>   > Could you elaborate what do you mean exactly "stop"?  Fail to load or
>   > initialize the driver, or silent output, DMA error...?
>   > 
>   > >  Sorry but don't know at what
>   > > point.  Card is an isa CS4236. Glad to provide
>   > > any other info/testing.
>   > 
>   > Any relevant kernel messages are welcome.  Also, if you passed any
>   > (module) options for the sound driver, show it, too.
>   > 
>   > The biggest change in ISA sound driver codes between 2.6.24 and 2.6.25
>   > is that we dropped the PnP resource re-configuration via module
>   > options of sound drivers.  They have to be adjusted via sysfs now 
>   > (if really needed).
>   > 
>   > Otherwise, if it really worked on 2.6.24, we have a good chance to
>   > identify the affecting changeset via bisect.  There are only a few
>   > changes for sound/isa.

> All I get is a cyclic noise burst (about 500ms frequency). 
> No options to module load, prior to 25 manually loaded modules
> with 'modprobe snd-cs4236',  with 25+ modules auto load at boot.
> 
> By removing "CONFIG_PNPBIOS" get total silence. So would assume the
> PNP change the source.
> 
> Currently running 26-rc1-git4.

There have been quite a few post .25 changes to PnP. Is there a difference 
between .24 and .25 or between .24/.25 on the one hand and .26-rc1-git4 on 
the other?

Also, does using PNPACPI instead of PNPBIOS change anything?

Rene.
