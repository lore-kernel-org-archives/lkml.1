Return-Path: <linux-kernel-owner+w=401wt.eu-S1763691AbYAUPaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763691AbYAUPaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 10:30:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760691AbYAUPYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 10:24:48 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41200 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756988AbYAUPYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 10:24:05 -0500
Date: Mon, 21 Jan 2008 15:24:02 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Torokhov <dtor@mail.ru>
Cc: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       Liam Girdwood <liam.girdwood@wolfsonmicro.com>,
       Rodolfo Giometti <giometti@enneenne.com>,
       Russell King <rmk@arm.linux.org.uk>,
       Marc Kleine-Budde <mkl@penugtronix.de>, Ian Molton <spyro@f2s.com>,
       Vincent Sanders <vince@kyllikki.org>,
       Andrew Zabolotny <zap@homelink.ru>, dbaryshkov@gmail.com
Subject: [UPDATED v3] WM97xx touchscreen drivers
Message-ID: <20080121152402.GA7518@rakim.wolfsonmicro.main>
Mail-Followup-To: Dmitry Torokhov <dtor@mail.ru>,
	linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
	Liam Girdwood <liam.girdwood@wolfsonmicro.com>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Russell King <rmk@arm.linux.org.uk>,
	Marc Kleine-Budde <mkl@penugtronix.de>, Ian Molton <spyro@f2s.com>,
	Vincent Sanders <vince@kyllikki.org>,
	Andrew Zabolotny <zap@homelink.ru>, dbaryshkov@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for the touchscreen controllers provided
by Wolfson Microelectronics WM97xx series chips in both polled and
streaming modes.

Changes since last submission:

 - Replace custom wm97xx bus type with use of the platform bus.
 - Remove reference counting on device open duplicated from input core.
 - Minor style and correctness cleanups.
