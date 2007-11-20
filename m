Return-Path: <linux-kernel-owner+w=401wt.eu-S1759415AbXKTSA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415AbXKTSA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 13:00:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbXKTSAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 13:00:50 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:50792 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbXKTSAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 13:00:50 -0500
Message-ID: <474320C4.2040600@oracle.com>
Date: Tue, 20 Nov 2007 10:00:36 -0800
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [PATCHv4 4/6] Allow setting FD_CLOEXEC flag for new sockets
References: <200711200653.lAK6rE31025888@devserv.devel.redhat.com>
In-Reply-To: <200711200653.lAK6rE31025888@devserv.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> +union indirect_params {
> +  struct {
> +    int flags;
> +  } file_flags;
> +};

Have you given thought to having to perform compat translation on this?
  Today it's only copied directly from the user pointer into the union
in the task_struct.

I'd love if we could only use fixed-width fields in the interface to
avoid the compat nonsense.

- z
