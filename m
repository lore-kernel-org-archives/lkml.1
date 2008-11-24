Return-Path: <linux-kernel-owner+w=401wt.eu-S1753300AbYKXNb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbYKXNb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 08:31:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbYKXNbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 08:31:19 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39502 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750983AbYKXNbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 08:31:18 -0500
Date: Mon, 24 Nov 2008 13:31:16 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: Switch WM8350 revision detection to a feature
	based model
Message-ID: <20081124133116.GA31269@rakim.wolfsonmicro.main>
References: <1227113220-17468-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20081124103755.GA3479@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081124103755.GA3479@sortiz.org>
X-Cookie: Do I have a lifestyle yet?
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2008 at 11:37:55AM +0100, Samuel Ortiz wrote:

> Dont you prefer to use the WM8350_REV_* values in your code rather than some
> undocumented constants like that ?
> I understand that reading the code below will make those constants obvious,
> but still...

I don't find them enormously helpful, TBH - the constant gets used in
exactly one place and there's been a bit of skew between what some of
the ID registers are called and thier actual meaning which doesn't help.

I'll repost with the #defines for the revisons added back, though.
