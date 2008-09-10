Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbYIJNIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbYIJNIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 09:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbYIJNIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 09:08:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53009 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087AbYIJNIQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 09:08:16 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: Ville =?iso-8859-1?q?Syrj=E4l=E4?= <syrjala@sci.fi>,
       Janne Grunau <j@jannau.net>
Subject: Re: [PATCH 06/18] lirc driver for the ATI USB RF remote receiver
Date: Wed, 10 Sep 2008 09:05:58 -0400
User-Agent: KMail/1.10.1 (Linux/2.6.25.16-1.fc10.x86_64; KDE/4.1.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Christoph Bartelmus <lirc@bartelmus.de>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <1220933164-10160-7-git-send-email-jwilson@redhat.com> <20080910095832.GA22422@sci.fi>
In-Reply-To: <20080910095832.GA22422@sci.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200809100905.58304.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 September 2008 05:58:32 Ville Syrjälä wrote:
> On Tue, Sep 09, 2008 at 12:05:51AM -0400, Jarod Wilson wrote:
> > +config LIRC_ATIUSB
> > +	tristate "ATI RF USB Receiver support"
> > +	default n
> > +	depends on LIRC_DEV
> > +	help
> > +	  Driver for the ATI USB RF remote receiver
> > +
>
> We already have proper input drivers for these devices (ati_remote and
> ati_remote2).

True, though I think some users still prefer using them with the lirc drivers 
for assorted reasons. Configuring something like mythtv to work with the 
ati_remote{,2} driver appears to be a bit more complex (or at least non-
standard vs. several other popular remotes) and not as functional vs. 
configuring mythtv w/lirc_atiusb.

http://evuraan.blogspot.com/2008/01/how-to-use-ati-remote-wonder-ii-
remote.html

-- 
Jarod Wilson
jarod@redhat.com

