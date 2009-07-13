Return-Path: <linux-kernel-owner+w=401wt.eu-S1753911AbZGMDr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbZGMDr5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 23:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbZGMDrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 23:47:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:59026 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbZGMDrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 23:47:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=k2Gqxbt/LP7itLG81bu2zKqWpmk2qa9Bfjoy7Pk6zLfOeXacie8Ev3tovR5bdn8C/0
         NFPGTdYX2MrlrK8cg2hY6Jb455j2vSsUDxuFXkYSBAcOch7qPvJHXrDBt0PQ/Lwcj+Iw
         lI9zsYNaYPQaqmiFUI36DZwyJDtoVHtYQwtvA=
Date: Sun, 12 Jul 2009 20:47:47 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: linux-kernel@vger.kernel.org, nico@cam.org
Subject: Re: [PATCH] trivial: ucb1400_ts: Fix a misleading function name
Message-ID: <20090713034747.GE10819@dtor-d630.eng.vmware.com>
References: <20090709144620.GC3646@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090709144620.GC3646@local>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 09, 2009 at 04:46:21PM +0200, Hans J. Koch wrote:
> The driver for UCB1400 touchscreen controllers contains a function named
> ucb1400_ts_pen_down(), but it returns 0 if the pen is down and 1 if it's up.
> This causes confusion, especially since it's used as a boolean truth value
> later in the code. This patch renames it.
> 
> Signed-off-by: Hans J. Koch <hjk@linutronix.de>
> 

Applied to 'next;' branch, thank you Hans.

-- 
Dmitry
