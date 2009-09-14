Return-Path: <linux-kernel-owner+w=401wt.eu-S1754655AbZINJ6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbZINJ6j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 05:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbZINJ6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 05:58:38 -0400
Received: from senator.holtmann.net ([87.106.208.187]:36749 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbZINJ6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 05:58:38 -0400
Subject: Re: [PATCH] Revert "[Bluetooth] Eliminate checks for impossible
 conditions in IRQ handler"
From: Marcel Holtmann <marcel@holtmann.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>
In-Reply-To: <1252905504-26666-1-git-send-email-vapier@gentoo.org>
References: <1252905504-26666-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain
Date: Mon, 14 Sep 2009 02:58:35 -0700
Message-Id: <1252922315.3421.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

> Commit ac019360fe3 changed the irq handler logic to BUG_ON rather than
> returning IRQ_NONE when the incoming argument is invalid.  While this
> works in most cases, it doesn't work when the IRQ is shared with other
> devices (or when DEBUG_SHIRQ is enabled).
> 
> So revert the previous change and replace the warning message with a
> comment.

please don't use git revert here. Send an updated patch that fixes this
issue correct and please send it with a proper subject line.

Regards

Marcel


