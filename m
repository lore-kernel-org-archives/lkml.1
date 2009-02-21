Return-Path: <linux-kernel-owner+w=401wt.eu-S1754943AbZBUH4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbZBUH4o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 02:56:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbZBUH4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 02:56:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:58787 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274AbZBUH4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 02:56:36 -0500
Message-ID: <499FB3B3.9070001@kernel.org>
Date: Sat, 21 Feb 2009 16:56:35 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, mingo@elte.hu
Subject: Re: [PATCH tj-percpu] percpu: clean up size usage
References: <1234958676-27618-1-git-send-email-tj@kernel.org>	<1234958676-27618-10-git-send-email-tj@kernel.org>	<499E5BF9.1060806@kernel.org> <20090220003743.d787107b.akpm@linux-foundation.org> <499F73BD.4030105@kernel.org> <499F7836.5090608@kernel.org> <499FB1D8.1090601@kernel.org> <499FB36B.4040502@kernel.org>
In-Reply-To: <499FB36B.4040502@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 21 Feb 2009 07:56:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> +static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk, intt off, int size,

intt should have been int.  Corrected version committed to tj-percpu.

Thanks.

-- 
tejun
