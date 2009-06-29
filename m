Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbZF2JrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbZF2JrJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 05:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484AbZF2Jq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 05:46:57 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47895 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbZF2Jq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 05:46:56 -0400
Date: Mon, 29 Jun 2009 10:46:59 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Daniel Ribeiro <drwyrm@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       inux-kernel <linux-kernel@vger.kernel.org>,
       openezx-devel <openezx-devel@lists.openezx.org>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Ilya Petrov <ilya.muromec@gmail.com>
Subject: Re: [PATCH] PCAP misc input driver (for 2.6.32)
Message-ID: <20090629094658.GE11855@sirena.org.uk>
References: <1246122592.3727.20.camel@brutus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246122592.3727.20.camel@brutus>
X-Cookie: Function reject.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 27, 2009 at 02:09:52PM -0300, Daniel Ribeiro wrote:
> This is a driver for misc input events for the PCAP2 PMIC, it handles
> the power button, headphone insertion/removal and the headphone button.

Depending on the power management capabilities of the CODEC it may be
better to support at laest the headphone insert/removal via the audio
driver as a jack to allow automatic management of the power for the
relevant paths within the CODEC.
