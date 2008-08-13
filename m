Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbYHMNqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbYHMNqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 09:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbYHMNq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 09:46:26 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:45226 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928AbYHMNqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 09:46:25 -0400
In-Reply-To: <20080812223636.1aff373a@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/4] integrity: TPM internel kernel interface
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OFC8FDDFED.7F31F3B8-ON852574A4.004A3882-852574A4.004BA8FA@us.ibm.com>
From: Kenneth Goldman <kgoldman@us.ibm.com>
Date: Wed, 13 Aug 2008 09:46:24 -0400
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Build V85_M1_05262008|May 26, 2008) at
 08/13/2008 09:46:23
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote on 08/12/2008 05:36:36 PM:

> > Being a TCG/TPM person, I can only address the first question.  The
> > intent is that the TPM is soldered to the planar/motherboard (the TCG
> > uses the phrase "bound to the platform").  I can't imagine
> > any manufacturer designing a pluggable TPM.  It would subvert PCR
> > measurements and thus attestation, data sealing, etc.
>
> So the security limit of your TPM is a soldering iron .. whoo. I'm not
> sure this is actually the case however as the secret of interest is in
> the TPM so even if I replaced the TPM the goodies already set up are in
> the TPM I just unsoldered surely ?

I suppose it depends on the precise interpretation of your technical
term "goodies".  :-)

One of the two primary uses of the TCG technology is protection
against an attack on the software.  The TCG uses the terms
attestation, integrity, platform measurements, etc.  For this class of>
"goodies", the TCG technology does not protect against hardware
attacks such as replacing the TPM with a bogus device, replacing the
CRTM hardware, flashing the CRTM using a JTAG cable, lifting a TPM pin>
and asserting reset, using a JTAG cable to set breakpoints and alter
memory, etc.

For this use case, the attack model is a remote, software attack.  The>
user is not considered the attacker.

(In the other primary use case, the user is the attacker, but it's an
entirely different discussion.)

(It's also important to note that the TPM itself does not completely
secure the platform.  There's an entire system design around it, which>
it why I try to say "TCG technology" rather than TPM.)

