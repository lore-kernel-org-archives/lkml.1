Return-Path: <linux-kernel-owner+w=401wt.eu-S1756680AbYDQXlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680AbYDQXlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 19:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755166AbYDQXk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 19:40:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52451 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754933AbYDQXk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 19:40:58 -0400
Date: Thu, 17 Apr 2008 16:40:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: mingo@elte.hu, tglx@linutronix.de, penberg@cs.helsinki.fi,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, jmorris@namei.org, sds@tycho.nsa.gov
Subject: Re: 2.6.25-mm1: not looking good
Message-Id: <20080417164034.e406ef53.akpm@linux-foundation.org>
In-Reply-To: <20080417160331.b4729f0c.akpm@linux-foundation.org>
References: <20080417160331.b4729f0c.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2008 16:03:31 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> I have maybe two hours in which to weed out whatever very-recently-added
> dud patches are causing this.  Any suggestions are welcome.
> 

With git-selinux at top-of tree it's repeatably hanging in the CPA
self-tests (git-x86 stuff).  Last two lines are:

CPA self-test:
 4k 8704 large 4847 gb 0 x 0[0-0] miss 0

(clear as mud ;))

I will find the config knob to disable that test.  Of course, it could be
telling me that CPA is buggy.
