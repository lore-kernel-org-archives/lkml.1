Return-Path: <linux-kernel-owner+w=401wt.eu-S1754654AbZA3Ivi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbZA3Ivi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 03:51:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754201AbZA3IvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 03:51:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:58772 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754160AbZA3IvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 03:51:21 -0500
Message-ID: <4982BF64.6080504@kernel.org>
Date: Fri, 30 Jan 2009 17:50:44 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Brian Gerst <brgerst@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] xen: setup percpu data pointers
References: <49818842.5020004@goop.org> <1233236625-17928-1-git-send-email-brgerst@gmail.com> <49822168.4020108@goop.org>
In-Reply-To: <49822168.4020108@goop.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 30 Jan 2009 08:50:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> We need to access percpu data fairly early, so set up the percpu
> registers as soon as possible.  We only need to load the appropriate
> segment register.  We already have a GDT, but its hard to change it
> early because we need to manipulate the pagetable to do so, and that
> hasn't been set up yet.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Committed 1-2 to #tj-percpu.  Thanks.

-- 
tejun
