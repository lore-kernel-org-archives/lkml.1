Return-Path: <linux-kernel-owner+w=401wt.eu-S940806AbXHJUjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940806AbXHJUjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 16:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932648AbXHJUi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 16:38:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765463AbXHJUi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 16:38:58 -0400
Date: Fri, 10 Aug 2007 21:38:54 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Jan Blunck <jblunck@suse.de>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 05/11] dm-snap: remove SECTOR_SHIFT define
Message-ID: <20070810203854.GG2064@agk.fab.redhat.com>
Mail-Followup-To: Jan Blunck <jblunck@suse.de>, dm-devel@redhat.com,
	linux-kernel@vger.kernel.org
References: <20070810200204.455820246@suse.de>> <20070810200205.703776854@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070810200205.703776854@suse.de>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2007 at 10:02:09PM +0200, Jan Blunck wrote:
> Sector size on Linux is always 512 bytes. Don't even try to give the
> impression this is changeable.

If that's what worries you, add a comment next to the definition,
perhaps?

It's there so you can easily locate all the places within dm that
perform these conversions by using a simple search.  Searching for '9'
wouldn't be as easy.  (I don't know about other people, but I find the
code easier to read the way it is.)

BTW When changing one thing across the whole of dm, you may combine
the sub-component patches into a single patch.

Alasdair
-- 
agk@redhat.com
