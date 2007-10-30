Return-Path: <linux-kernel-owner+w=401wt.eu-S1753615AbXJ3ASj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbXJ3ASj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 20:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752325AbXJ3ASb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 20:18:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52079 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbXJ3ASa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 20:18:30 -0400
Message-ID: <47267832.1060003@zytor.com>
Date: Mon, 29 Oct 2007 17:17:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <gcosta@redhat.com>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, rusty@rustcorp.com.au,
       jeremy@goop.org, --cc@redhat.com, mingo@elte.hu, avi@quramnet.com,
       kvm-devel@lists.sourceforge.net,
       Glauber de Oliveira Costa <glauber@t60.localdomain>
Subject: Re: [PATCH] raise tsc clocksource rating
References: <11936994092607-git-send-email-gcosta@redhat.com>
In-Reply-To: <11936994092607-git-send-email-gcosta@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
> From: Glauber de Oliveira Costa <glauber@t60.localdomain>
> 
> tsc is very good time source (when it does not have drifts, does not
> change it's frequency, i.e. when it works), so it should have its rating
> raised to a value greater than, or equal 400.
> 
> Since it's being a tendency among paravirt clocksources to use values
> around 400, we should declare tsc as even better: So we use 500.
> 
> This patch also touches the comments on clocksource.h, which suggests
> that 499 would be a limit on the rating values.
> 
> Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>

Are you sure these paravirt sources don't intentionally trump the TSC?

	-hpa

