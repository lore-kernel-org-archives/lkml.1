Return-Path: <linux-kernel-owner+w=401wt.eu-S1756999AbYAQTjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999AbYAQTjx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 14:39:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbYAQTjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 14:39:45 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55399 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751481AbYAQTjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 14:39:44 -0500
Date: Thu, 17 Jan 2008 11:38:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: 2.6.24-rc8-mm1 (BUG: sched_rt)
Message-Id: <20080117113822.f45d4da3.akpm@linux-foundation.org>
In-Reply-To: <20080117111401.354f8949.randy.dunlap@oracle.com>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
	<20080117084833.dc946466.randy.dunlap@oracle.com>
	<1200589864.5159.6.camel@twins>
	<20080117111401.354f8949.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2008 11:14:01 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> > Does reverting that fix it?
> 
> Ack.  Andrew, do you want this hotfix?
> 
> ---
> From:   Peter Zijlstra <peterz@infradead.org>
>                                             
> Revert the BUG_ON(). Condition is OK and happens.
> 
> Tested-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks - I already added that to
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc8/2.6.24-rc8-mm1/hot-fixes/

There are quite a few fixes there so I'd remind people to apply those as
well before testing.

