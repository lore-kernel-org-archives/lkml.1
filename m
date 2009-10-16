Return-Path: <linux-kernel-owner+w=401wt.eu-S1751882AbZJPW40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbZJPW40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 18:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbZJPW4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 18:56:25 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:33198 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbZJPW4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 18:56:25 -0400
Message-ID: <4AD8F971.2090805@nortel.com>
Date: Fri, 16 Oct 2009 16:53:37 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Con Kolivas <kernel@kolivas.org>
CC: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: BFS cpu scheduler v0.304 stable release
References: <200910162158.58054.kernel@kolivas.org>
In-Reply-To: <200910162158.58054.kernel@kolivas.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Oct 2009 22:56:24.0576 (UTC) FILETIME=[E2DD8000:01CA4EB3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2009 04:58 AM, Con Kolivas wrote:

> to this, BFS also uses sub-tick accounting. What BFS does _not_ now feature is
> support for CGROUPS. The average user should neither need to know what these
> are, nor should they need to be using them to have good desktop behaviour.

That said, it's useful for embedded purposes and I could see some use in
that area for your BFS scheduler since they often care about latency and
tend to use low numbers of cpus.

> It is surprisingly difficult to get accurate CPU accounting, and in many cases,
> the accounting is done by simply determining what is happening at the precise
> moment a timer tick fires off.

With sched_clock() it would seem that this is not as applicable as it
used to be.

Chris

