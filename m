Return-Path: <linux-kernel-owner+w=401wt.eu-S1752708AbXEXTK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbXEXTK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 15:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750809AbXEXTKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 15:10:20 -0400
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:38168 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750806AbXEXTKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 15:10:18 -0400
In-Reply-To: <200705242225.30225.sshtylyov@ru.mvista.com>
References: <200705172142.26739.sshtylyov@ru.mvista.com> <200705242225.30225.sshtylyov@ru.mvista.com>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <1d767eeda7a427230eb320edbb6784c7@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: linuxppc-dev@ozlabs.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 2.6.21-rt7] PowerPC: fix clockevents for classic CPUs
Date: Thu, 24 May 2007 21:10:15 +0200
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  	 * We must write a positive value to the decrementer to clear
> -	 * the interrupt on the IBM 970 CPU series.  In periodic mode,
> -	 * this happens when the decrementer gets reloaded later, but
> -	 * in one-shot mode, we have to do it here since an event handler
> -	 * may skip loading the new value...
> +	 * the interrupt on POWER4+ compatible CPUs.

No, it is *not* only on POWER4+ compatible CPUs.  Sigh.


Segher

