Return-Path: <linux-kernel-owner+w=401wt.eu-S1753909AbYKHL3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbYKHL3Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 06:29:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753067AbYKHL3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 06:29:14 -0500
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:34603 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbYKHL3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 06:29:13 -0500
Date: Sat, 8 Nov 2008 12:29:02 +0100
From: Arjan Opmeer <arjan@opmeer.net>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-ID: <20081108112901.GA12987@adopmeer.homeip.net>
References: <49142351.9080805@euromail.se> <20081108005125.GA24783@adopmeer.homeip.net> <49156D54.8060109@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49156D54.8060109@euromail.se>
User-Agent: Mutt/1.5.18 (2008-05-17)
Subject: Re: [PATCH] input: Add a detailed multi-touch finger data report
	protocol
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Henrik,

On Sat, Nov 08, 2008 at 11:43:32AM +0100, Henrik Rydberg wrote:
> 
> For chips that cannot produce the above events, one simply reports less
> data. [...]
> The minimum set of data is TOUCH, POSITION_X and POSITION_Y. If touch
> pressure information is not given in trackpad dimension units, use a
> specific range.

The Elantech touchpad does not seem to be able to report pressure, only
finger coordinates.

> I believe all current drivers are able to produce this data.

The Elantech driver is not... :)

> It is designed to bring advanced gestures to the linux desktop.

Certainly. Have you already thought about the rest of the path from driver
to application, ie kernel driver -> X.org driver -> X events -> toolkit
events -> application?

For instance does the X.org driver interpret the data and emit a zoom or
rotate event based on the finger position and movement? As far as I know
those event do not exist and would have to be added to X.org as well as the
toolkits like GTK+ and Qt. It could be a long implementation process... :(


Arjan

