Return-Path: <linux-kernel-owner+w=401wt.eu-S1760341AbYFGBIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760341AbYFGBIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756225AbYFGBGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:06:06 -0400
Received: from saeurebad.de ([85.214.36.134]:58060 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756124AbYFGBGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:06:04 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, greg@kroah.com,
       justinmattock@gmail.com, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH] isight_firmware: Avoid crash on loading invalid firmware
References: <dd18b0c30806041213x45b7efdfo42de9b214a7ce9df@mail.gmail.com>
	<20080606002601.a0f6c47c.akpm@linux-foundation.org>
	<dd18b0c30806060137j7edc751se364ff21cfc8911b@mail.gmail.com>
	<20080606121136.GA9087@srcf.ucam.org>
	<20080606110711.a9a6a4f6.akpm@linux-foundation.org>
	<dd18b0c30806061110qd3100b4p1ee9f8ef493a56c6@mail.gmail.com>
	<dd18b0c30806061138h69c87d6am898a4eb409d379e1@mail.gmail.com>
	<20080606185548.GB8576@kroah.com>
	<20080606192135.GA16727@srcf.ucam.org>
	<20080606123511.38ffbdde.akpm@linux-foundation.org>
	<20080606194856.GA17708@srcf.ucam.org>
Date: Sat, 07 Jun 2008 03:05:16 +0200
In-Reply-To: <20080606194856.GA17708@srcf.ucam.org> (Matthew Garrett's message
	of "Fri, 6 Jun 2008 20:48:56 +0100")
Message-ID: <873anq5a2b.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett <mjg59@srcf.ucam.org> writes:

> Different tools generate slightly different formats of the isight 
> firmware. Ensure that the firmware buffer is not overrun, while still 
> ensuring that the correct amount of data is written if trailing data is 
> preseent. Fixes crash reported by Justin Mattock.

You don't like the word `present', do you? ;)

	Hannes
