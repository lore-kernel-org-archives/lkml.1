Return-Path: <linux-kernel-owner+w=401wt.eu-S932199AbXLTW1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199AbXLTW1x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 17:27:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755614AbXLTW1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 17:27:42 -0500
Received: from torres.zugschlus.de ([85.214.68.41]:54239 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbXLTW1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 17:27:40 -0500
Date: Thu, 20 Dec 2007 23:27:38 +0100
From: Marc Haber <mh+linux-kernel@zugschlus.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
Message-ID: <20071220222738.GA24489@torres.zugschlus.de>
References: <20071204114125.GA17310@torres.zugschlus.de> <20071204161811.GB15974@stusta.de> <47584E35.7030409@tmr.com> <20071208220345.GE20441@stusta.de> <475EAFF9.9020405@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475EAFF9.9020405@tmr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2007 at 10:42:49AM -0500, Bill Davidsen wrote:
> The original point was that urandom draws entropy from random, and that 
> it is an an inobvious and unintentional drain on the entropy pool. At 
> least that's how I read it.

And you are reading it correct. At least one of the major TLS
libraries does it this way, putting unnecessary stress on the kernel
entropy pool. While I now consider this a bug in the library, there
surely are gazillions of similiarily flawed applications out there in
the wild.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Mannheim, Germany  |  lose things."    Winona Ryder | Fon: *49 621 72739834
Nordisch by Nature |  How to make an American Quilt | Fax: *49 3221 2323190
