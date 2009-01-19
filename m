Return-Path: <linux-kernel-owner+w=401wt.eu-S1758607AbZASRiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607AbZASRiA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 12:38:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbZASRhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 12:37:51 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:3417 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbZASRhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 12:37:51 -0500
Date: Mon, 19 Jan 2009 17:37:48 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: pHilipp Zabel <philipp.zabel@gmail.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] regulator: Pass regulator init data as explict argument when registering
Message-ID: <20090119173747.GE22473@sirena.org.uk>
References: <1232372226-23319-1-git-send-email-broonie@opensource.wolfsonmicro.com> <74d0deb30901190924q4bc4d1ffu5211a161af3f5e6e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74d0deb30901190924q4bc4d1ffu5211a161af3f5e6e@mail.gmail.com>
X-Cookie: Variables don't
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 06:24:50PM +0100, pHilipp Zabel wrote:

> Good, I had a local patch that would pass bq24022_mach_info in
> regulator_init_data->driver_data instead of platform_data.
> Now that there is a possibility to pass platform_data, is there still
> need for the driver_data field in regulator_init_data and for the
> regulator_get_init_drvdata() function?

I'd not expect so, no.  The driver doesn't get to see the constraints.
