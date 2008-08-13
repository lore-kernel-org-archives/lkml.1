Return-Path: <linux-kernel-owner+w=401wt.eu-S1755923AbYHMQkC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbYHMQkC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 12:40:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbYHMQjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 12:39:53 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:60771 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbYHMQjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 12:39:52 -0400
In-Reply-To: <20080813144040.30d40ec5@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/4] integrity: TPM internel kernel interface
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OFFBB340CE.91B8B32B-ON852574A4.005A2AEE-852574A4.005B89B5@us.ibm.com>
From: Kenneth Goldman <kgoldman@us.ibm.com>
Date: Wed, 13 Aug 2008 12:39:49 -0400
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Build V85_M1_05262008|May 26, 2008) at
 08/13/2008 12:39:49
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote on 08/13/2008 09:40:40 AM:

> > "goodies", the TCG technology does not protect against hardware
> > attacks such as replacing the TPM with a bogus device, replacing the
> > CRTM hardware, flashing the CRTM using a JTAG cable, lifting a TPM pin>
> > and asserting reset, using a JTAG cable to set breakpoints and alter
> > memory, etc.
> >
> > For this use case, the attack model is a remote, software attack.  The>
> > user is not considered the attacker.
>
> Surely if I can replace your TPM with alternative hardware then I can
> also replace it with virtualised software traps.

Replacing with alternative hardware is outside the attack model.  For this
use case, the TCG assumes the user will not be attacking himself.

Replacing with software is a valid remote attack.  It will be detected
through the TCG platform measurement process.  The local defense is
"sealing" data to trusted measurements.  The remote defense is
"attestation" or "quote", getting signed measurements and deciding
whether to trust them.

> [If there is a good document on this btw please just point me there
> instead and I'll go read further]

The TPM main specification (design principles) discusses measurements,>
reporting, attestation, and so on.

The "TCG PC Client Specific Implementation Specification For Conventional
BIOS" is specific to the PC platform (there are specifications for mobile
devices, printers, storage, etc.) but section 1.2 has a good discussion
of the concepts.

https://www.trustedcomputinggroup.org/home

(Feel free to email me privately if this is becoming off topic for the
mailing list.)

