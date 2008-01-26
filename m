Return-Path: <linux-kernel-owner+w=401wt.eu-S1753789AbYAZPSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789AbYAZPSo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 10:18:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbYAZPSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 10:18:35 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1715 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbYAZPSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 10:18:34 -0500
Date: Sat, 26 Jan 2008 15:18:20 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Torokhov <dtor@mail.ru>, linux-input@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org,
       Liam Girdwood <liam.girdwood@wolfsonmicro.com>,
       Rodolfo Giometti <giometti@enneenne.com>,
       Russell King <rmk@arm.linux.org.uk>,
       Marc Kleine-Budde <mkl@pengutronix.de>, Ian Molton <spyro@f2s.com>,
       Vincent Sanders <vince@kyllikki.org>,
       Andrew Zabolotny <zap@homelink.ru>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>
Message-ID: <20080126151820.GA13899@sirena.org.uk>
Mail-Followup-To: Dmitry Torokhov <dtor@mail.ru>,
	linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
	Liam Girdwood <liam.girdwood@wolfsonmicro.com>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Russell King <rmk@arm.linux.org.uk>,
	Marc Kleine-Budde <mkl@pengutronix.de>, Ian Molton <spyro@f2s.com>,
	Vincent Sanders <vince@kyllikki.org>,
	Andrew Zabolotny <zap@homelink.ru>,
	Dmitry Baryshkov <dbaryshkov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Cookie: Someone is speaking well of you.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: 82.32.140.119
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [UPDATED v4] WM97xx touchscreen drivers
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for the touchscreen controllers provided
by Wolfson Microelectronics WM97xx series chips in both polled and
streaming modes.

Changes since last submission:
 - Fix from Dmitry Baryshkov for build with CONFIG_PM.
 - Add the web site to the MAINTAINERS entry.
