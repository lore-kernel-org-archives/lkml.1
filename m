Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbZFYVX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbZFYVX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 17:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752978AbZFYVXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 17:23:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45956 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751684AbZFYVXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 17:23:50 -0400
Date: Thu, 25 Jun 2009 14:23:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard =?ISO-8859-1?Q?R=F6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       kwangwoo.lee@gmail.com, thierry.reding@avionic-design.de,
       soni.trilok@gmail.com
Subject: Re: [PATCH 2/2] tsc2007: make platform callbacks optional
Message-Id: <20090625142344.d7c5b72d.akpm@linux-foundation.org>
In-Reply-To: <4A40C28E.1070109@mocean-labs.com>
References: <4A40C28E.1070109@mocean-labs.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 13:54:54 +0200
Richard R__jfors <richard.rojfors.ext@mocean-labs.com> wrote:

> The platform callbacks are only called if supplied. Makes the driver
> to fallback on only pressure calculation to decide when the pen is up.
> 

Again, I don't understand the reason for the change from the above
description.

Is there some driver in the tree which does not implement
->get_pendown_state()?  If so, it will oops, won't it?  Which driver is
that?

Or is there some other driver which you're developing which does not
implement ->get_pendown_state()?

If the latter, why should the problem be solved in this way, rather
than implementing an empty ->get_pendown_state() within that driver?

etc.   More details, please.
