Return-Path: <linux-kernel-owner+w=401wt.eu-S1753163AbXHTGhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbXHTGhd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 02:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751152AbXHTGhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 02:37:24 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:47255 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750877AbXHTGhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 02:37:24 -0400
Message-Id: <1187591842.11769.1206227263@webmail.messagingengine.com>
X-Sasl-Enc: pj3gIt5ITCrMxZ0cXZgOQePpxj/9jcc7DsXzY4iv6BHj 1187591842
From: "Clemens Ladisch" <clemens@ladisch.de>
To: "David Griffith" <dgriffi@cs.csubak.edu>
Cc: linux-kernel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <Pine.GSO.4.55.0708100242000.25856@helios.cs.csubak.edu>
   <20070816093703.sndy0gg44gk0o0ko@webmail.df.eu>
   <Pine.GSO.4.55.0708160308450.24052@helios.cs.csubak.edu>
   <20070816174510.6o8cray64g8kosos@webmail.df.eu>
   <Pine.GSO.4.55.0708161417270.9354@helios.cs.csubak.edu>
   <1187331453.13767.1205847147@webmail.messagingengine.com>
   <Pine.GSO.4.55.0708170202270.26403@helios.cs.csubak.edu>
Subject: Re: MOTU Fastlane USB MIDI interface
In-Reply-To: <Pine.GSO.4.55.0708170202270.26403@helios.cs.csubak.edu>
Date: Mon, 20 Aug 2007 08:37:22 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Griffith wrote:
> On Fri, 17 Aug 2007, Clemens Ladisch wrote:
> > David Griffith wrote:
> > > On Thu, 16 Aug 2007, Clemens Ladisch wrote:
> > > > Please try "amidi -d -p virtual" and playing a .mid file to this port with
> > > > aplaymidi.
> > >
> > > $ aplaymidi -p "virtual" castle2.mid
> > > Invalid port virtual - No such file or directory
> >
> > Sorry, the name of the correspondig sequencer port is different,
> > probably "128:0"; see the output of "aplaymidi -l".
> 
> $ aplaymidi -l
>  Port    Client name                      Port name
>  14:0    Midi Through                     Midi Through Port-0
>  16:0    Ensoniq AudioPCI                 ES1371
>  20:0    Fastlane                         Fastlane MIDI A
>  20:1    Fastlane                         Fastlane MIDI B
> 
> $ aplaymidi -p 20:0 casablan.mid
> 
> Nothing is written to the Fastlane.  No lights.  Nothing.

Please run "amidi -d -p virtual" and then play to the virtual port
created by amidi, to see if MIDI playback works even without hardware.


Regards,
Clemens
