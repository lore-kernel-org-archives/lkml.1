Return-Path: <linux-kernel-owner+w=401wt.eu-S1754192AbZENUKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbZENUKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 16:10:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754334AbZENUJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 16:09:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:62918 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105AbZENUJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 16:09:51 -0400
Date: Fri, 15 May 2009 01:09:47 +0500
From: Constantin Baranov <const@mimas.ru>
To: Tobias_Mueller@twam.info
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH 001/001] leds: alix-leds2 fixed for Award BIOS
Message-Id: <20090515010947.4016ba66.const@mimas.ru>
In-Reply-To: <17be05570905140208n5fd695aayfad221808f70ac21@mail.gmail.com>
References: <17be05570905130710s1192729cqafa09127f6c34bf9@mail.gmail.com>
	<20090513151415.6e84fd82.akpm@linux-foundation.org>
	<17be05570905140208n5fd695aayfad221808f70ac21@mail.gmail.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do these boards support DMI? In that case, I suggest to write another
function, say alix_award_present(). It shall first check DMI and then
initialize GPIOs.

On Thu, 14 May 2009 11:08:45 +0200 Tobias Müller <Tobias_Mueller@twam.info> wrote:
> 2009/5/14 Andrew Morton <akpm@linux-foundation.org>:
> > Will this cause problems on boards which are _not_ running that BIOS?
> No. These initialisations is already done there by BIOS, but setting
> the registers twice doesn't matter. It's just configurating these pins
> as an output.
> 
> > IOW, is this change backward-compatible?
> Yes.
