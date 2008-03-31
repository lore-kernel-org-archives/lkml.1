Return-Path: <linux-kernel-owner+w=401wt.eu-S1756750AbYCaNVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbYCaNVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 09:21:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754387AbYCaNVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 09:21:00 -0400
Received: from lazybastard.de ([212.112.238.170]:51038 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbYCaNU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 09:20:59 -0400
Date: Mon, 31 Mar 2008 15:20:47 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Adrian Hunter <ext-adrian.hunter@nokia.com>
Cc: ext Jan Engelhardt <jengelh@computergmbh.de>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>, joern@lazybastard.org
Subject: Re: [RFC PATCH] UBIFS - new flash file system
Message-ID: <20080331132047.GA31660@logfs.org>
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com> <alpine.LNX.1.10.0803311428270.2554@fbirervta.pbzchgretzou.qr> <47F0DD49.7010302@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47F0DD49.7010302@nokia.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 March 2008 15:47:05 +0300, Adrian Hunter wrote:
> >
> >And how does it compare to logfs?
> 
> We don't know a lot about logfs, so you will really have to make
> your own comparison.  However our general impressions are as follows:
> 
> 1. In our testing logfs file operations seem to be much slower,
> see http://osl.sed.hu/wiki/ubifs/index.php/IOzone

Shiny numbers!  Performance has improved significantly in the last six
month.  Still worth a closer look.

> 3. logfs does not seem to have bad-block handling.

Bad blocks at mkfs time are handled, blocks turning bad later on aren't
yet.

> 4. logfs does not seem to have wear-leveling.

It does.

Jörn

-- 
Fools ignore complexity.  Pragmatists suffer it.
Some can avoid it.  Geniuses remove it.
-- Perlis's Programming Proverb #58, SIGPLAN Notices, Sept.  1982
