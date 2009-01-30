Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbZA3IvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbZA3IvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 03:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbZA3IvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 03:51:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:58771 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbZA3IvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 03:51:14 -0500
Message-ID: <4982BF53.105@kernel.org>
Date: Fri, 30 Jan 2009 17:50:27 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: pass in cpu number to switch_to_new_gdt()
References: <49818842.5020004@goop.org> <1233236625-17928-1-git-send-email-brgerst@gmail.com>
In-Reply-To: <1233236625-17928-1-git-send-email-brgerst@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 30 Jan 2009 08:50:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Gerst wrote:
> Impact: cleanup, prepare for xen boot fix.
> 
> Xen needs to call this function very early to setup the GDT and
> per-cpu segments.  Remove the call to smp_processor_id() and just
> pass in the cpu number.
> 
> Signed-off-by: Brian Gerst <brgerst@gmail.com>

Committed to #tj-percpu.  Thanks.

-- 
tejun
