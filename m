Return-Path: <linux-kernel-owner+w=401wt.eu-S1757922AbXJKHoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922AbXJKHoi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 03:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755982AbXJKHoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 03:44:30 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:10875 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663AbXJKHo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 03:44:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Jjp+0Zp+0Jb+Gr/meKk6Lz3/BJEDDUV1K1/5QrALvbkQqkdRdWamNnhsiWI4/9QBNHsxFkAayuyIp58Lp2PByQhAKXbI9stQ5hCEYWcRyRsDjzX6yz4UVopEox33JHwkf4IP3jIFKX7haCUH2rrF/m2YJmKH3ByYlvttKUiJw2I=
Message-ID: <b647ffbd0710110044r5424d7ffi58fc64221a440c7d@mail.gmail.com>
Date: Thu, 11 Oct 2007 09:44:28 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Peter Williams" <pwil3058@bigpond.net.au>
Subject: Re: [PATCH] sched: Rationalize sys_sched_rr_get_interval()
Cc: "Ingo Molnar" <mingo@elte.hu>, "Nick Piggin" <npiggin@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20071011065946.GB32125@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <470D7055.4090000@bigpond.net.au> <20071011065946.GB32125@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2007, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Peter Williams <pwil3058@bigpond.net.au> wrote:
>
> > -#define MIN_TIMESLICE                max(5 * HZ / 1000, 1)
> > -#define DEF_TIMESLICE                (100 * HZ / 1000)
>
> hm, this got removed by Dmitry quite some time ago. Could you please do
> this patch against the sched-devel git tree:

here is the commit:
http://git.kernel.org/?p=linux/kernel/git/mingo/linux-2.6-sched-devel.git;a=commit;h=dd3fec36addd1bf76b05225b7e483378b80c3f9e

I had also considered introducing smth like
sched_class::task_timeslice() but decided it was not worth it.


-- 
Best regards,
Dmitry Adamushko
