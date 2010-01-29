Return-Path: <linux-kernel-owner+w=401wt.eu-S1752450Ab0A2SPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab0A2SPF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 13:15:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246Ab0A2SPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 13:15:04 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33528 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab0A2SPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 13:15:03 -0500
Date: Fri, 29 Jan 2010 18:15:00 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] WM8994 core driver
Message-ID: <20100129181500.GD19270@sirena.org.uk>
References: <20100125192554.GA11200@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100125192554.GA11200@rakim.wolfsonmicro.main>
X-Cookie: no maintenance:
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 07:25:54PM +0000, Mark Brown wrote:
> This patch series implements core support for the WM8994 audio CODEC.
> Since the WM8994 is a large device and includes both GPIOs and
> integrated LDOs which need be represented via the relevant subsystems
> for integration with the rest of the kernel a MFD core device is
> provided to manage chip access.

Unfortunately I discovered another sync issue with the platform data.
I'll resend the series shortly with that corrected, please ignore this
posting.
