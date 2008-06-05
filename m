Return-Path: <linux-kernel-owner+w=401wt.eu-S1762562AbYFETDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762562AbYFETDW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 15:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbYFETDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 15:03:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37311 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752066AbYFETDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 15:03:14 -0400
Date: Thu, 5 Jun 2008 12:02:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Thomas Tuttle" <ttuttle@google.com>
Cc: mpm@selenic.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] pagemap: Modify add_to_pagemap to use copy_to_user
 instead of put_user.
Message-Id: <20080605120221.c09dc274.akpm@linux-foundation.org>
In-Reply-To: <4ca0a85e0806050804q4c164105uc386dcae2ccd21d@mail.gmail.com>
References: <4ca0a85e0806050804q4c164105uc386dcae2ccd21d@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jun 2008 11:04:21 -0400
"Thomas Tuttle" <ttuttle@google.com> wrote:

> While fiddling with pagemap, I discovered a bug in add_to_pagemap.

so...  afaict we have some fairly significant problems in here and a
version 2 of the patchset is in order?

If so, when preparing that patchset please do have a think about which
of the fixes you believe should be backported into 2.6.25.x and prepare
the patches so that those fixes come first, to ease that backporting.

Thanks.
