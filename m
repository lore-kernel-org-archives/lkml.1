Return-Path: <linux-kernel-owner+w=401wt.eu-S1753076AbZLBMCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbZLBMCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 07:02:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbZLBMCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 07:02:36 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56188 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbZLBMCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 07:02:36 -0500
Date: Wed, 2 Dec 2009 12:02:41 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: H??gander Jouni <jouni.hogander@nokia.com>
Cc: "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>,
       "De-Schrijver Peter (Nokia-D/Helsinki)" 
	<Peter.De-Schrijver@nokia.com>,
       "Keski-Saari Juha.1 (EXT-Teleca/Helsinki)" 
	<ext-juha.1.keski-saari@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>
Subject: Re: Doubt about Regulator Framework and VBAT use case
Message-ID: <20091202120240.GA19094@sirena.org.uk>
References: <20091130104102.GA16608@esdhcp037198.research.nokia.com> <20091130114515.GB10968@rakim.wolfsonmicro.main> <87iqcpk3wp.fsf@trdhcp146196.ntc.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87iqcpk3wp.fsf@trdhcp146196.ntc.nokia.com>
X-Cookie: Formatted to fit your screen.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 01:32:06PM +0200, H??gander Jouni wrote:
> ext Mark Brown <broonie@opensource.wolfsonmicro.com> writes:

> > I'd add it as a fixed voltage regulator and either not specify the
> > voltage or specify the nominal voltage.

> I was preparing patch for this when I noticed that fixed voltage
> regulator can control only one regulator. Are you aware of any ongoing
> work to enable control for multiple regulators in
> fixed-voltage-regulator?

It's just a platform device configured with platform data, you can
instantiate as many fixed voltage regulators in your system as you care
to using the current driver.
