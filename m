Return-Path: <linux-kernel-owner+w=401wt.eu-S1755486AbZBTHRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbZBTHRA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 02:17:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752358AbZBTHQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 02:16:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:59288 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081AbZBTHQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 02:16:50 -0500
Message-ID: <499E58CB.1000005@kernel.org>
Date: Fri, 20 Feb 2009 16:16:27 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, mingo@elte.hu
Subject: Re: [PATCH 02/10] module: fix out-of-range memory access
References: <1234958676-27618-1-git-send-email-tj@kernel.org> <1234958676-27618-3-git-send-email-tj@kernel.org>
In-Reply-To: <1234958676-27618-3-git-send-email-tj@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 20 Feb 2009 07:16:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Impact: subtle memory access bug fix
> 
> percpu_modalloc() may access pcpu_size[-1].  The access won't change
> the value by itself but it still is read/write access and dangerous.
> Fix it.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Dropped as this can never happen.

-- 
tejun
