Return-Path: <linux-kernel-owner+w=401wt.eu-S932409AbXDMTd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409AbXDMTd4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 15:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932431AbXDMTd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 15:33:56 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:14232 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409AbXDMTdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 15:33:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ZhXvi7OfvIaHZjqxgKlaIoy4zsoBq4MgHefDZm3zjG7EhJFnwe5EnmDKA28/mwL29ow8j0Zs9OYWEnbjQcYpaYylweAnjt4vE0vqKmGq2+wZyQZ0/CTlCXLUNk4dipPVBDR9JXU0slAH0lGb8/kV7h/JWXGRlwBYJ4HbaIMw49Y=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: Loud "pop" coming from hard drive on reboot
Date: Fri, 13 Apr 2007 21:42:29 +0200
User-Agent: KMail/1.9.6
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
References: <461D4E2C.6000704@redhat.com> <Pine.LNX.4.61.0704112347230.20436@yvahk01.tjqt.qr> <461D5C24.9080506@redhat.com>
In-Reply-To: <461D5C24.9080506@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704132142.29582.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 April 2007, Chuck Ebbert wrote:
> Jan Engelhardt wrote:
> > On Apr 11 2007 17:35, Chuck Ebbert wrote:
> >> Jan Engelhardt wrote:
> >>> On Apr 11 2007 17:07, Chuck Ebbert wrote:
> >>>> When I reboot my notebook, it powers off and powers back on.
> >>>> On poweroff a loud snapping noise seems to be coming from the
> >>>> hard drive. Today I noticed there is no "shutdown: hda" on
> >>>> the console when I reboot. Whne I do a normal poweroff the
> >>>> message is displayed and there is no noise. Should the IDE
> >>>> code be changed so it always shuts down the drive?
> >>> What sort of notebook? What sort of harddisk?
> >> Compaq Presario V2000 series, with a new Seagate ST9120821A
> >> 120GB 5400RPM drive.
> > 
> > I specifically hoped you might have a TOSHIBA MK2003GAH,
> > which does a hard unload when left idle for too long.
> > 
> > Only on reboots huh?
> > 
> > What happens if you reboot another OS, freebsd f.ex.? (You can try that off
> > CD1)
> 
> Now we're getting somewhere. There is some other OS on here because
> it's required for doing BIOS updates. I booted it and shut down.
> The power cycle count increased but the power off retract count did not.
> 
> The counts are:
> 
> power cycle ... 111
> power off retract ... 92
> 
> The difference is now 19; it was 18 before.

Is the noise present if you reboot the other OS?
Does it result in Power-Off_Retract count increase?

Bart
