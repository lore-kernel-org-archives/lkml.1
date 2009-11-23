Return-Path: <linux-kernel-owner+w=401wt.eu-S1756084AbZKWCez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbZKWCez (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 21:34:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbZKWCey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 21:34:54 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:42144 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbZKWCey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 21:34:54 -0500
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <4B09E2F9.7040403@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 22 Nov 2009 18:34:49 -0800
In-Reply-To: <4B09E2F9.7040403@kernel.org> (Yinghai Lu's message of "Sun\, 22 Nov 2009 17\:18\:49 -0800")
Message-ID: <m1my2em0ja.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH] x86: crash kernel reserve with reserve_early -v2
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> use find_e820_area/reserve_early instead.
>
> -v2: address Eric's request, to restore original semantics.
>      will fail, if the provided address can not be used.

This patch seems reasonable.

YH what is the benefit of using reserve_early, and moving
reserve_crashkernel earlier?

Eric
