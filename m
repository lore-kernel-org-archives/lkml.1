Return-Path: <linux-kernel-owner+w=401wt.eu-S1754106AbZCIRYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbZCIRYF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 13:24:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752402AbZCIRXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 13:23:54 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:43551 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbZCIRXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 13:23:53 -0400
Date: Mon, 9 Mar 2009 18:23:48 +0100
From: Daniel Mack <daniel@caiaq.de>
To: Matt Reimer <mreimer@vpop.net>
Cc: linux-kernel@vger.kernel.org, Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>,
       Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] ds2760_battery.c: fix division by zero
Message-ID: <20090309172348.GA30434@buzzloop.caiaq.de>
References: <1236614002-9102-1-git-send-email-daniel@caiaq.de> <49B5427E.6000107@vpop.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B5427E.6000107@vpop.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 09:23:26AM -0700, Matt Reimer wrote:
> Daniel Mack wrote:
> > The 'battery remaining capacity' calculation in
> > drivers/power/ds2760_battery.c lacks a parameter check to a division
> > operation which causes the kernel to oops on my board.
> >   
> Signed-off-by: Matt Reimer <mreimer@vpop.net>

Who's going to queue it up? IMO, as it is a real bug fix, it should
be considered .29 material.

Daniel

