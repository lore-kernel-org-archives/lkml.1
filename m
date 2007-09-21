Return-Path: <linux-kernel-owner+w=401wt.eu-S1758239AbXIUMvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239AbXIUMvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 08:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755212AbXIUMvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 08:51:13 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:57882 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544AbXIUMvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 08:51:12 -0400
Date: Fri, 21 Sep 2007 14:51:11 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Peter Stahlir <peter.stahlir@googlemail.com>
cc: Muhammad Tayyab <mail.tayyab@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Git as a filesystem
In-Reply-To: <fbe8b1780709210446i24a7ee84reaa232be2d3d089e@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0709211449370.30810@fbirervta.pbzchgretzou.qr>
References: <fbe8b1780709210348n1b1bd739rf5bfe0a73381b3ec@mail.gmail.com> 
 <46F3AAC1.5050409@gmail.com>  <fbe8b1780709210437s18b24945jab5a3ffa07646427@mail.gmail.com>
 <fbe8b1780709210446i24a7ee84reaa232be2d3d089e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 21 2007 13:46, Peter Stahlir wrote:
>
>For example, imagine running a complete Debian mirror on top of a
>Debian system with gitfs. How big would the packfile be for this 252GB
>beast?

Probably 252 GB. Lots of the packages are already compressed, and
each time a minimal change is done, the bytestream changes, so long
story short, deltifying between to compressed streams is likely to
deltify horribly.
