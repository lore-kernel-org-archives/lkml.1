Return-Path: <linux-kernel-owner+w=401wt.eu-S1756176AbZKWTln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbZKWTln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 14:41:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756101AbZKWTll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 14:41:41 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:38533 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779AbZKWTlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 14:41:39 -0500
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Andi Kleen <andi@firstfloor.org>, Neil Horman <nhorman@redhat.com>
Subject: Re: [Resend Patch] kexec: allow to shrink reserved memory
References: <20091123093958.4963.38592.sendpatchset@localhost.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 23 Nov 2009 11:41:40 -0800
In-Reply-To: <20091123093958.4963.38592.sendpatchset@localhost.localdomain> (Amerigo Wang's message of "Mon\, 23 Nov 2009 04\:37\:02 -0500")
Message-ID: <m1d439f2q3.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang <amwang@redhat.com> writes:

> This patch implements shrinking the reserved memory for crash kernel,
> if it is more than enough.
>
> For example, if you have already reserved 128M, now you just want 100M,
> you can do:
>
> # echo $((100*1024*1024)) > /sys/kernel/kexec_crash_size
>
> Note, you can only do this before loading the crash kernel.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Looks good to me.

Eric


