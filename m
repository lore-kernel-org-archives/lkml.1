Return-Path: <linux-kernel-owner+w=401wt.eu-S1762296AbYBLKRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762296AbYBLKRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 05:17:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760132AbYBLKRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 05:17:41 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34360 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759793AbYBLKRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 05:17:40 -0500
Date: Tue, 12 Feb 2008 10:17:38 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Torokhov <dtor@mail.ru>
Cc: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       Liam Girdwood <liam.girdwood@wolfsonmicro.com>,
       Rodolfo Giometti <giometti@enneenne.com>,
       Russell King <rmk@arm.linux.org.uk>,
       Pete MacKay <linux01@architechnical.net>,
       Marc Kleine-Budde <mkl@penugtronix.de>, Ian Molton <spyro@f2s.com>,
       Vincent Sanders <vince@kyllikki.org>,
       Andrew Zabolotny <zap@homelink.ru>, dbaryshkov@gmail.com
Subject: [UPDATED v6] WM97xx touchscreen drivers
Message-ID: <20080212101738.GB21039@rakim.wolfsonmicro.main>
Mail-Followup-To: Dmitry Torokhov <dtor@mail.ru>,
	linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
	Liam Girdwood <liam.girdwood@wolfsonmicro.com>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Russell King <rmk@arm.linux.org.uk>,
	Pete MacKay <linux01@architechnical.net>,
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
streaming modes.  The series can also be pulled via git from:

	git://opensource.wolfsonmicro.com/linux-2.6-touch upstream

This version incorporates minor bug fixes.
