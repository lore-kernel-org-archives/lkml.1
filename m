Return-Path: <linux-kernel-owner+w=401wt.eu-S1030826AbXCTBGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030826AbXCTBGs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 21:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030827AbXCTBGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 21:06:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030826AbXCTBGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 21:06:47 -0400
Message-ID: <45FF33A5.7010909@redhat.com>
Date: Mon, 19 Mar 2007 21:06:45 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH] split file and anonymous page queues #2
References: <45FF3052.0@redhat.com>
In-Reply-To: <45FF3052.0@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> Split the anonymous and file backed pages out onto their own pageout
> queues.  This we do not unnecessarily churn through lots of anonymous
> pages when we do not want to swap them out anyway.

> Please take this patch for a spin and let me know what goes well
> and what goes wrong.

In order to make testing easier, I have put some kernel RPMs
up on http://people.redhat.com/riel/vmsplit/

Any benchmark results are welcome, especially bad ones.
I want to make sure this thing runs as well as the current
VM in every situation, while also fixing the problems described
in my previous mail.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
