Return-Path: <linux-kernel-owner+w=401wt.eu-S1760763AbZAGTWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760763AbZAGTWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 14:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756809AbZAGTV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 14:21:59 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:33786 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756598AbZAGTV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 14:21:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kM2OG1qnzCl0VN03I4bh6QDpC6RtuE0JKwbzop1d2JWNqkXsixFDeOPgXL4BdIuZmn
         V19zvUwLMOWs8e8M0Ni4epgRdtqCNNIxNRwjRbmSK5yg1Pa8kUk1dNwia4BCtGEia592
         O5N40UFFlSDKVwwaKguXG/UdPHZvKX4thZyJI=
Subject: Re: Status/support for Linux HECI from Intel? (for temp/voltage
 monitoring)
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
In-Reply-To: <alpine.DEB.1.10.0901071142200.29147@p34.internal.lan>
References: <alpine.DEB.1.10.0812300700410.11356@p34.internal.lan>
	 <4964DB3E.6080908@intel.com>
	 <alpine.DEB.1.10.0901071142200.29147@p34.internal.lan>
Content-Type: text/plain
Date: Wed, 07 Jan 2009 21:21:51 +0200
Message-Id: <1231356111.6648.2.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-07 at 11:42 -0500, Justin Piszcz wrote:
> 
> On Wed, 7 Jan 2009, Dan Williams wrote:
> 
> > Justin Piszcz wrote:
> >> The HECI interface would allow lm_sensors developers to grab the
> >> temperatures off the chips on the board.
> >> 
> >> From 2005(?)-2008 there was some chatter about supporting it but it never
> >> seemed to happen, is there any eventual planned support for supporting
> >> Intel's HECI interface or if the user wants to see the
> >> temperatures/voltages just buy a different motherboard with an ITE I/O
> >> controller?
> >> 
> >> I have a couple DG965WH boards and it would be nice to see the
> >> temperature of the chipset etc without having to reboot into the BIOS.
> >> 
> >
> > Hi Justin,
> >
> > I am not up to date on the progress in this area, but perhaps this site 
> > (http://www.openamt.org/) has what you are looking for?
> >
> > Regards,
> > Dan
> >
> 
> Yeah that is the site-- however, will it ever get merged?  I have not 
> heard anything about it for a year or so.

Nope, the heci is just a controller, but we need a way to tell that
controller to show us the temperature data.
But intel hasn't released the QST sdk, and probably never will.

Sad, 

Best regards,
	Maxim Levitsky



