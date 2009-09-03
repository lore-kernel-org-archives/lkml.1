Return-Path: <linux-kernel-owner+w=401wt.eu-S1755168AbZICL7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbZICL7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 07:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755118AbZICL7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 07:59:46 -0400
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4078 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101AbZICL7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 07:59:44 -0400
Message-ID: <4A9FAFB0.6060200@aimvalley.nl>
Date: Thu, 03 Sep 2009 13:59:44 +0200
From: Norbert van Bolhuis <nvbolhuis@aimvalley.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Corrado Zoccolo <czoccolo@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: CONFIG_NO_HZ could cause software timeouts
References: <4A9F9F64.5080305@aimvalley.nl> <4e5e476b0909030422m745af2e6mb8dd0148c2341e9d@mail.gmail.com>
In-Reply-To: <4e5e476b0909030422m745af2e6mb8dd0148c2341e9d@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrado Zoccolo wrote:
> Is XIP enabled? It seems that the xip_udelay is not very accurate, and
> may be the cause of what you are seeing.
> 

no it isn't. CONFIG_MTD_XIP has been disabled.
nor did someone supsended the write (chip->state remains FL_WRITING).
