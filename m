Return-Path: <linux-kernel-owner+w=401wt.eu-S1756325AbXHTAYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325AbXHTAYS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 20:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbXHTAYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 20:24:10 -0400
Received: from helios.cs.csubak.edu ([136.168.201.112]:35210 "EHLO
	helios.cs.csubak.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbXHTAYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 20:24:09 -0400
Date: Sun, 19 Aug 2007 17:23:57 -0700 (PDT)
From: David Griffith <dgriffi@cs.csubak.edu>
To: Clemens Ladisch <clemens@ladisch.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: MOTU Fastlane USB MIDI interface
In-Reply-To: <1187331453.13767.1205847147@webmail.messagingengine.com>
Message-ID: <Pine.GSO.4.55.0708170202270.26403@helios.cs.csubak.edu>
References: <Pine.GSO.4.55.0708100242000.25856@helios.cs.csubak.edu>  
 <20070816093703.sndy0gg44gk0o0ko@webmail.df.eu>  
 <Pine.GSO.4.55.0708160308450.24052@helios.cs.csubak.edu>  
 <20070816174510.6o8cray64g8kosos@webmail.df.eu>  
 <Pine.GSO.4.55.0708161417270.9354@helios.cs.csubak.edu>
 <1187331453.13767.1205847147@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.5 (--)
X-Spam-Report: ---- Start Spam Filter Report
	Filter Analysis score is (-2.5/5.0)
	-0.0 NO_RELAYS              Informational: message was not relayed via SMTP
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.1 AWL                    AWL: From: address is in the auto white-list
	---- End Spam Filter results
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Aug 2007, Clemens Ladisch wrote:

> David Griffith wrote:
> > On Thu, 16 Aug 2007, Clemens Ladisch wrote:
> > > Please try "amidi -d -p virtual" and playing a .mid file to this port with
> > > aplaymidi.
> >
> > $ aplaymidi -p "virtual" castle2.mid
> > Invalid port virtual - No such file or directory
>
> Sorry, the name of the correspondig sequencer port is different,
> probably "128:0"; see the output of "aplaymidi -l".

$ aplaymidi -l
 Port    Client name                      Port name
 14:0    Midi Through                     Midi Through Port-0
 16:0    Ensoniq AudioPCI                 ES1371
 20:0    Fastlane                         Fastlane MIDI A
 20:1    Fastlane                         Fastlane MIDI B

$ aplaymidi -p 20:0 casablan.mid

Nothing is written to the Fastlane.  No lights.  Nothing.

-- 
David Griffith
dgriffi@cs.csubak.edu
