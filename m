Return-Path: <linux-kernel-owner+w=401wt.eu-S1758603AbZIOTWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758603AbZIOTWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755693AbZIOTWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:22:21 -0400
Received: from dan.rpsys.net ([93.97.175.187]:61225 "EHLO dan.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148AbZIOTWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:22:21 -0400
Subject: Re: [PATCH 1/3] backlight: Provide two stage registration
From: Richard Purdie <rpurdie@rpsys.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1253031583-11286-1-git-send-email-mjg@redhat.com>
References: <1253031583-11286-1-git-send-email-mjg@redhat.com>
Content-Type: text/plain
Date: Tue, 15 Sep 2009 20:18:42 +0100
Message-Id: <1253042322.30165.52.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-15 at 17:19 +0100, Matthew Garrett wrote:
> The backlight class currently allocates and registers a backlight device
> in a single function, making it impossible for certain backlight parameters
> to be set before the device becomes visible to userspace. This can cause
> problems if userspace wins the race and manages to read any of these values
> before they've been set, and also makes it harder to extend information
> that we may wish to provide to the rest of the kernel at registration time.
> 
> This patch breaks the register and unregister functions into two,
> separating allocation and registration. The old functions are left to ease
> transition.

I understand the problem but the second patch in this series bothers me
- an additional 300 lines of error handling in each driver.

Could we not pass an optional pointer to a properties structure to
create the backlight with instead or find a better way to solve this?

Cheers,

Richard

-- 
Richard Purdie
Intel Open Source Technology Centre

