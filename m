Return-Path: <linux-kernel-owner+w=401wt.eu-S1030389AbXBZSML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030389AbXBZSML (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 13:12:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030392AbXBZSML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 13:12:11 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:54057 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030389AbXBZSMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 13:12:10 -0500
X-Sasl-enc: SeQ+fnVEb/tmushZAhH0fzZB/GFpsJ9dYAVnERtwTHYU 1172513528
Date: Mon, 26 Feb 2007 15:12:02 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Jiri Kosina <jikos@jikos.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: ibm-acpi: improve backlight power handling
Message-ID: <20070226181202.GH2909@khazad-dum.debian.net>
References: <Pine.LNX.4.64.0702260154460.10496@twin.jikos.cz> <1172490091.5824.30.camel@localhost.localdomain> <Pine.LNX.4.64.0702261329270.10496@twin.jikos.cz> <20070226142157.GA2909@khazad-dum.debian.net> <1172501357.5824.91.camel@localhost.localdomain> <20070226152035.GB2909@khazad-dum.debian.net> <20070226161203.GD2909@khazad-dum.debian.net> <1172507907.5824.105.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1172507907.5824.105.camel@localhost.localdomain>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Feb 2007, Richard Purdie wrote:
> On Mon, 2007-02-26 at 13:12 -0300, Henrique de Moraes Holschuh wrote:
> > @@ -1707,7 +1708,8 @@ static int brightness_write(char *buf)
> >  
> >  static int brightness_update_status(struct backlight_device *bd)
> >  {
> > -	return brightness_set(bd->props.brightness);
> > +	return brightness_set((bd->props.fb_blank == FB_BLANK_UNBLANK)? 
> > +				bd->props.brightness : 0);
> >  }
> >  
> >  static struct backlight_ops ibm_backlight_data = {
> 
> Should we be looking at bd->props.power here too?

Probably.  I will update the patch.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
