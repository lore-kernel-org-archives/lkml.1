Return-Path: <linux-kernel-owner+w=401wt.eu-S1754629AbZE2BNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbZE2BNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 21:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753848AbZE2BMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 21:12:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58581 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754598AbZE2BMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 21:12:52 -0400
Message-ID: <4A1F36E4.9000007@cn.fujitsu.com>
Date: Fri, 29 May 2009 09:14:12 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: mingo@elte.hu, x86@kernel.org, linux-kernel@vger.kernel.org,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 3/3] trace: events_filter, fix lock imbalances
References: <1243497289-18591-1-git-send-email-jirislaby@gmail.com> <1243497289-18591-3-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1243497289-18591-3-git-send-email-jirislaby@gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> apply_event_filter and apply_subsystem_event_filter omits an unlock
> on one fail path each. Fix that.
> 

Thanks, but this has been fixed.

You are not using latest tip tree, are you?

> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Tom Zanussi <tzanussi@gmail.com>
