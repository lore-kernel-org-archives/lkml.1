Return-Path: <linux-kernel-owner+w=401wt.eu-S1754906AbYHTVx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbYHTVx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 17:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbYHTVxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 17:53:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33588 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146AbYHTVxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 17:53:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: 2.6.27-rc3: 'APIC error on CPU1: 00(40)', but only on resume!
Date: Wed, 20 Aug 2008 23:56:32 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>
References: <200808202106.41058.elendil@planet.nl> <200808202138.13302.rjw@sisk.pl> <200808202226.45655.elendil@planet.nl>
In-Reply-To: <200808202226.45655.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808202356.33036.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 20 of August 2008, Frans Pop wrote:
> Thanks for the quick responses Rafael.
> 
> On Wednesday 20 August 2008, Rafael wrote:
> > On Wednesday, 20 of August 2008, Frans Pop wrote:
> > > <snip>
> > > CPU1 is up
> > > ACPI: Waking up from system sleep state S3
> > > APIC error on CPU1: 00(40)
> > > ACPI: EC: non-query interrupt received, switching to interrupt mode
> > > </snip>
> >
> > Does the box work after that?
> 
> Yes, it does. Both cores seem to be working fine.
> 
> The only weirdness I can see (only spotted that just now) is that both 
> cores will always seem to be changing frequency together (using ondemand 
> governor), even when 'top' shows one as idle. On my other Core Duo system 
> (an older desktop) the cores react independently.
> This also happens immediately after boot (so not suspend related) and may 
> be "normal" or unrelated.

On my box I see many "APIC error on CPU1: 00(40)" messages that don't seem
to be related to anything obviously bad and I've alwas been seeing them.

Please monitor things for some time to check if you can find a connection
between those messages and any erroneous behavior.

Thanks,
Rafael
