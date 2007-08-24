Return-Path: <linux-kernel-owner+w=401wt.eu-S1757189AbXHXPDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189AbXHXPDE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 11:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbXHXPCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 11:02:55 -0400
Received: from webmailfront01.ispgateway.de ([80.67.16.111]:44587 "EHLO
	webmailfront01.ispgateway.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752072AbXHXPCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 11:02:54 -0400
Message-ID: <20070824170226.hu6yyhyy8oocs4c0@webmail.df.eu>
Date: Fri, 24 Aug 2007 17:02:26 +0200
From: Clemens Ladisch <clemens@ladisch.de>
To: David Griffith <dgriffi@cs.csubak.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: MOTU Fastlane USB MIDI interface
References: <Pine.GSO.4.55.0708100242000.25856@helios.cs.csubak.edu>
	<20070816093703.sndy0gg44gk0o0ko@webmail.df.eu>
	<Pine.GSO.4.55.0708160308450.24052@helios.cs.csubak.edu>
	<20070816174510.6o8cray64g8kosos@webmail.df.eu>
	<Pine.GSO.4.55.0708161417270.9354@helios.cs.csubak.edu>
	<1187331453.13767.1205847147@webmail.messagingengine.com>
	<Pine.GSO.4.55.0708170202270.26403@helios.cs.csubak.edu>
	<1187591842.11769.1206227263@webmail.messagingengine.com>
	<Pine.GSO.4.55.0708200042470.26684@helios.cs.csubak.edu>
In-Reply-To: <Pine.GSO.4.55.0708200042470.26684@helios.cs.csubak.edu>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: domainFACTORY
X-Originating-IP: 213.238.46.206
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Griffith wrote:
> On Mon, 20 Aug 2007, Clemens Ladisch wrote:
>> David Griffith wrote:
>> > $ aplaymidi -p 20:0 casablan.mid
>> >
>> > Nothing is written to the Fastlane.  No lights.  Nothing.
>>
>> Please run "amidi -d -p virtual" and then play to the virtual port
>> created by amidi, to see if MIDI playback works even without hardware.
>
> $ aplaymidi -p 128:0 casablan.mid
>
> At this point, MIDI data flew by in the xterm in which amidi was running.

Hmmm, it's either the driver or device.

Please uncomment the "#define DUMP_PACKETS" in line 58 of sound/usb/usbmidi.c
and recompile the driver.  All MIDI data should then be visible in the system
log.


Regards,
Clemens

