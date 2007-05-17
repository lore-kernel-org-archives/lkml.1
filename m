Return-Path: <linux-kernel-owner+w=401wt.eu-S1760420AbXEQT12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760420AbXEQT12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 15:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756246AbXEQT1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 15:27:21 -0400
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:41477 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755874AbXEQT1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 15:27:21 -0400
In-Reply-To: <200705172142.26739.sshtylyov@ru.mvista.com>
References: <200705172142.26739.sshtylyov@ru.mvista.com>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <f9afbdb49bc1f935153305315770bccd@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: linuxppc-dev@ozlabs.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: decrementer clockevent driver
Date: Thu, 17 May 2007 21:27:17 +0200
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +	 * We must write a positive value to the decrementer to clear
> +	 * the interrupt on the IBM 970 CPU series.  In periodic mode,
> +	 * this happens when the decrementer gets reloaded later, but
> +	 * in one-shot mode, we have to do it here since an event handler
> +	 * may skip loading the new value...

Nothing special about 970 here -- on *every* PowerPC,
a decrementer exception exists as long as the high
bit of the decrementer equals 1.  BookE is different
of course.  Some other CPUs might deviate from the
architecture as well.


Segher

