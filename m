Return-Path: <linux-kernel-owner+w=401wt.eu-S1761548AbXIZPZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761548AbXIZPZx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 11:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761352AbXIZPZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 11:25:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759587AbXIZPZO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 11:25:14 -0400
Date: Wed, 26 Sep 2007 11:25:10 -0400
From: Rik van Riel <riel@redhat.com>
To: Jan =?UTF-8?B?S3VuZHLDoXQ=?= <jkt@gentoo.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kswapd high CPU usage with no swap
Message-ID: <20070926112510.314e8775@cuia.boston.redhat.com>
In-Reply-To: <46FA09E8.7010101@gentoo.org>
References: <46F852B6.7030207@gentoo.org>
	<20070924223444.62f0622d@bree.surriel.com>
	<46F8DF55.2030905@gentoo.org>
	<20070925213156.68fceea2@bree.surriel.com>
	<46FA09E8.7010101@gentoo.org>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2007 09:27:36 +0200
Jan Kundrát <jkt@gentoo.org> wrote:

> Rik van Riel wrote:
> > Could you try out the attached patch, too?
> 
> Sorry, I wasn't able to apply it against 2.6.22-gentoo-r3 and vanilla
> 2.6.22.7; I don't have the "order" member in the "struct scan_control"
> and also the bit about "if (sync_writeback == PAGEOUT_IO_SYNC &&
> may_enter_fs)" was missing so there was no "else" branch to add (and
> it seemd pretty significant to me). What version should I patch
> against?

Sorry, the patch is against 2.6.23-rc7.

> When this is sorted out, should I keep the previous patch [1] applied
> as well?

That doesn't hurt.

-- 
All Rights Reversed
