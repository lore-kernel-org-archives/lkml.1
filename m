Return-Path: <linux-kernel-owner+w=401wt.eu-S1762471AbYEFMoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762471AbYEFMoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 08:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762869AbYEFMoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 08:44:13 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:5537 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757448AbYEFMoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 08:44:11 -0400
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] mm/cgroup.c add error check
From: Andi Kleen <andi@firstfloor.org>
References: <20080506195216.4A6D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Date: Tue, 06 May 2008 14:43:48 +0200
In-Reply-To: <20080506195216.4A6D.KOSAKI.MOTOHIRO@jp.fujitsu.com> (KOSAKI Motohiro's message of "Tue, 06 May 2008 20:02:44 +0900")
Message-ID: <87wsm7bo1n.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 06 May 2008 12:36:52.0020 (UTC) FILETIME=[DC2F9740:01C8AF75]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> writes:

> on heavy workload, call_usermodehelper() may failure
> because it use kzmalloc(GFP_ATOMIC).

Better just fix it to not use GFP_ATOMIC in the first place.

-Andi
