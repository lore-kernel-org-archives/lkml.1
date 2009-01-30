Return-Path: <linux-kernel-owner+w=401wt.eu-S1752873AbZA3NId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbZA3NId (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 08:08:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755196AbZA3NIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 08:08:19 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4798 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914AbZA3NIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 08:08:18 -0500
Date: Fri, 30 Jan 2009 12:54:08 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       kay.sievers@vrfy.org, weiyi.huang@gmail.com,
       Andrew Victor <avictor.za@gmail.com>
Subject: Re: [PATCH 1/1] atmel-ssc: fix misuse of dev_dbg when requested ssc instance is not found
Message-ID: <20090130125408.GE18825@sirena.org.uk>
References: <1232369876-19428-1-git-send-email-hans-christian.egtvedt@atmel.com> <20090130102654.10e4aafc@hskinnemoen-d830> <20090130013628.4672215d.akpm@linux-foundation.org> <20090130105057.7d0acaec@hcegtvedt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090130105057.7d0acaec@hcegtvedt>
X-Cookie: Hackers of the world, unite!
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 30, 2009 at 10:50:57AM +0100, Hans-Christian Egtvedt wrote:

> 1 sound/soc/atmel/sam9g20_wm8731.c        274 ssc = ssc_request(0);
> 2 sound/soc/atmel/playpaq_wm8510.c        399 ssc = ssc_request(0);
> 3 sound/spi/at73c213.c                    980 chip->ssc = ssc_request(board->ssc_id);

> The two first are a bit suspicious since they hard code id 0.

They are ASoC board drivers so are already entirely specific to one
board (or family of boards).
