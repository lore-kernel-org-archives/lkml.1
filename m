Return-Path: <linux-kernel-owner+w=401wt.eu-S1754938AbZBQWit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbZBQWit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 17:38:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbZBQWik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 17:38:40 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59391
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753463AbZBQWik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 17:38:40 -0500
Date: Tue, 17 Feb 2009 14:38:24 -0800 (PST)
Message-Id: <20090217.143824.121552155.davem@davemloft.net>
To: jeremy@goop.org
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, gitster@pobox.com, mingo@elte.hu,
       caglar@pardus.org.tr
Subject: Re: [PATCH] Add *.rej to .gitignore
From: David Miller <davem@davemloft.net>
In-Reply-To: <499B1729.5040802@goop.org>
References: <499B1729.5040802@goop.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy@goop.org>
Date: Tue, 17 Feb 2009 11:59:37 -0800

> *.rej files really are unwanted.  If there are any .rej files, they can be found by
> some other means (perhaps git itself could warn when committing with *.rej files present,
> or add some distinct notion of "ignored files" vs "never commit" files).
> 
> (This effectively reverts 1f5d3a6b6532e25a5cdf1f311956b2b03d343a48)
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

I don't know about this.

I really want to know if there are reject files there if I
am checking to see if my tree is clean.

This has caught many patch application errors for myself
personally in the past, so I really don't want git to
start silently ignoring those things.

People should delete reject file explicitly, as they are
evidence of a patch that would not apply cleanly.  If you
abort trying to add the patch, fine, but cleaning up the
reject files is part of that operation.

