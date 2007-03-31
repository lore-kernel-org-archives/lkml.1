Return-Path: <linux-kernel-owner+w=401wt.eu-S933275AbXCaB7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933275AbXCaB7K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 21:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933304AbXCaB7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 21:59:10 -0400
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:40063 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933275AbXCaB7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 21:59:09 -0400
Date: Fri, 30 Mar 2007 21:59:05 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Daniel Walker <dwalker@mvista.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       johnstul@us.ibm.com
Subject: Re: [PATCH 9/9] clocksource: refactor duplicate registration checking
In-Reply-To: <20070330184616.429016225@mvista.com>
Message-ID: <Line.LNX.4.64.0703302158380.29742@d.namei>
References: <20070330184541.583153763@mvista.com> <20070330184616.429016225@mvista.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2007, Daniel Walker wrote:

>  /**
>   * clocksource_register - Used to install new clocksources
>   * @t:		clocksource to be registered
>   *
> - * Returns -EBUSY if registration fails, zero otherwise.
> + * Always returns zero.
>   */
>  int clocksource_register(struct clocksource *c)

Return should be void, then.



- James
-- 
James Morris
<jmorris@namei.org>
