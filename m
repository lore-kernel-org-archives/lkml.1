Return-Path: <linux-kernel-owner+w=401wt.eu-S1754186AbYFNGGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbYFNGGt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 02:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbYFNGGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 02:06:39 -0400
Received: from ik-out-1112.google.com ([66.249.90.178]:57618 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbYFNGGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 02:06:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:content-type
         :content-transfer-encoding:message-id;
        b=NRvK4v3FVNq2y6YYXdRL0g6QN+wZw+xGJA8trkrOLYquOWEaGKe2prvHk7QAPrSVZ3
         IGk2l7jea/c9O4Bap+lAMJysYIL9MH03dj7vDecnOHK3KpEleqe1nYqHTl1ojP6SOuJ1
         bxUuh+rKI/Zmgz39KM/TImmgMkWmryYXBbnpU=
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
Date: Sat, 14 Jun 2008 06:03:59 +0000
User-Agent: KMail/1.9.9
Cc: Greg KH <greg@kroah.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       Hannes Reinecke <hare@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-usb@vger.kernel.org
References: <200806010415.05290.chris2553@googlemail.com> <485047C1.3020200@s5r6.in-berlin.de> <48504B94.9050100@s5r6.in-berlin.de>
In-Reply-To: <48504B94.9050100@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200806140603.59061.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 June 2008, Stefan Richter wrote:
> I wrote:
> > /etc/udev/rules.d/05-udev-early.rules:ACTION=="add",
> > KERNEL=="[0-9]*:[0-9]*", SUBSYSTEM=="scsi", WAIT_FOR_SYSFS="ioerr_cnt"
> >
> > Whatever this rule is good for...  Maybe the pattern should be
> > "[0-9]+(:[0-9]+){3}" to match logical units only.
>
> Actually no; looks like these are just glob(7) patterns.  Then the
> pattern might already be OK since host devices' and target devices'
> names don't start with decimal numbers.

For Slackware 12.0.0, the rule is:

ACTION=="add", KERNEL=="[0-9]*:[0-9]*", SUBSYSTEM=="scsi", 
WAIT_FOR_SYSFS="ioerr_cnt"

Using that rule instaed of the old one in the Slackware rules file included with 
udev appears to result in the same behaviour as with the old rule and kernel < 
2.6.26.

Unless someone warns me otherwise, I think I'll go with that on my (homebrewed) 
system, so thanks to everyone for your help.

Chris
-- 
Beauty is in the eye of the beerholder.
