Return-Path: <linux-kernel-owner+w=401wt.eu-S1760786AbXERQ61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760786AbXERQ61 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 12:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756287AbXERQ6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 12:58:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49017 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754630AbXERQ6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 12:58:20 -0400
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [RFC][PATCH] Make prepare_namespace() wait for devices
References: <464853D9.70904@drzeus.cx>
From: Andi Kleen <andi@firstfloor.org>
Date: 18 May 2007 19:55:11 +0200
In-Reply-To: <464853D9.70904@drzeus.cx>
Message-ID: <p73ejlednk0.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman <drzeus-list@drzeus.cx> writes:
>     
>     If the device never shows up than we will hang in an infinite loop.
>     Previously we panic:ed instead, so this behaviour should be no
>     worse.


Actually that's not correct. With panic=30 and lilo -R and a working 
backup kernel a system can recover from this. With your endless loop it can't.

Always add some kind of timeout.

-Andi


