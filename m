Return-Path: <linux-kernel-owner+w=401wt.eu-S1760895AbZJNAxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760895AbZJNAxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 20:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760223AbZJNAxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 20:53:40 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:45696 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760758AbZJNAxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 20:53:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QEkQKH+GJKdvGWo2xmDkC2cTCpjfbwv9hDprGuuXWvvd4urqB9CmQJTYXFrTq27pB5
         NSFPIRrwamHItGdq975aMTzRebrw9LUpPcNRUHyDMoFQxx1hqj0aGFBRcm+PL9s/nisN
         6uEPkpJ1Wb/OSYB25FfRa0WQUW/mB4/c1oxhw=
Date: Wed, 14 Oct 2009 02:51:31 +0200
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-input@vger.kernel.org
Subject: Re: [bisected regression] Touchpad "paste" stops working after
	suspend to RAM
Message-ID: <20091014005131.GA4371@Pilar.aei.mpg.de>
References: <20091012100929.GA4402@Pilar.aei.mpg.de> <20091013032414.GC2887@core.coreip.homeip.net> <20091013121109.GB4619@Pilar.aei.mpg.de> <20091013182643.GC21593@core.coreip.homeip.net> <20091013190819.GA7555@Pilar.aei.mpg.de> <20091013194654.GD21593@core.coreip.homeip.net> <20091013202459.GE21593@core.coreip.homeip.net> <20091013231641.GA4404@Pilar.aei.mpg.de> <20091013235607.GA28819@core.coreip.homeip.net> <20091013235701.GB28819@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091013235701.GB28819@core.coreip.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 13.Oct'09 at 16:57:01 -0700, Dmitry Torokhov wrote:
> On Tue, Oct 13, 2009 at 04:56:08PM -0700, Dmitry Torokhov wrote:
> > On Wed, Oct 14, 2009 at 01:16:41AM +0200, Carlos R. Mafra wrote:
> > > [restoring Cc: list]
> > > 
> > > On Tue 13.Oct'09 at 13:24:59 -0700, Dmitry Torokhov wrote:
> > > >
> > > > Could you please try this patch (again if you could post dmesg that
> > > > would be great). Thank you!
> > > 
> > > The patch quoted below also fixes the problem. I attached the
> > > syslog with i8042.debug (with a s2ram in the middle) to the
> > > bugzilla: 
> > > 
> > > http://bugzilla.kernel.org/show_bug.cgi?id=14392
> > > 
> > 
> > Still not quite happy, although it is better. I don't understand why
> > your box likes to reply on AUX port when command is sent via keyboard
> > port.
> > 
> > Could you please try booting with atkbd.reset (I assume keyboard is
> > built in) and send me yet another dmesg.
> > 
> 
> Oh, yes, keep the last patch applied. Thanks!

I uploaded the dmesg with atkbd.reset (and i8042.debug too, btw)
to the bugzilla.

Thanks for taking care of this, Dmitry!
