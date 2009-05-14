Return-Path: <linux-kernel-owner+w=401wt.eu-S1754945AbZENVcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbZENVcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 17:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbZENVcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 17:32:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:1994 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbZENVcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 17:32:09 -0400
Date: Fri, 15 May 2009 02:32:02 +0500
From: Constantin Baranov <const@mimas.ru>
To: Tobias_Mueller@twam.info
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH 001/001] leds: alix-leds2 fixed for Award BIOS
Message-Id: <20090515023202.57387cb2.const@mimas.ru>
In-Reply-To: <17be05570905141323l31ee6f9o71698e57aec4b698@mail.gmail.com>
References: <17be05570905130710s1192729cqafa09127f6c34bf9@mail.gmail.com>
	<20090513151415.6e84fd82.akpm@linux-foundation.org>
	<17be05570905140208n5fd695aayfad221808f70ac21@mail.gmail.com>
	<20090515010947.4016ba66.const@mimas.ru>
	<17be05570905141323l31ee6f9o71698e57aec4b698@mail.gmail.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 May 2009 22:23:51 +0200 Tobias Müller <Tobias_Mueller@twam.info> wrote:
>> Do these boards support DMI? In that case, I suggest to write another
> Unfortunately, they don't.
> I already searched the BIOS for characteristical strings, but it
> seems to be there very basic version of Award BIOS. f It had a

OK, 'double' initialization seems good.
I will test it on my ALIX.2c3 later.

> alix_present(), because at the moment the force=1 parameter
> is needed on boards with Award BIOS.

It should be stated in the Kconfig help message that the 'force' is
required for boards with Award BIOS.
