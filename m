Return-Path: <linux-kernel-owner+w=401wt.eu-S1754496AbZHKM4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbZHKM4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750927AbZHKM4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:56:07 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38320 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbZHKM4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:56:07 -0400
Date: Tue, 11 Aug 2009 13:56:03 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Rapoport <mike@compulab.co.il>
Cc: me@felipebalbi.com, Liam Girdwood <lrg@slimlogic.co.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: Question about userspace-consumer
Message-ID: <20090811125603.GH24947@sirena.org.uk>
References: <20090810200553.GB4652@gandalf> <20090810215800.GB4528@sirena.org.uk> <20090811054438.GA7176@gandalf> <4A815F64.8000105@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A815F64.8000105@compulab.co.il>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 11, 2009 at 03:09:08PM +0300, Mike Rapoport wrote:
> Felipe Balbi wrote:

> > that said, power supply framework and regulator framework seem to be
> > well enough for implementing the basic support for SBS-enabled charging
> > scheme.

> As far as I understood SBS scheme, the host has very little impact on the
> charging process. Most of the charging is handled by Smart Battery and Smart
> Battery Charger without any host intervention.

I strongly suspect that in at least some designs the battery charger
itself will be at least partially dumb and the battery charger part of
the spec done by software running on the host CPU - there's examples in
the spec which seem to back that up.
