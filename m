Return-Path: <linux-kernel-owner+w=401wt.eu-S1758744AbYGPVvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758744AbYGPVvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 17:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755556AbYGPVvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 17:51:45 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:36274 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521AbYGPVvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 17:51:44 -0400
Subject: Re: [PATCH 00/20] generic show_mem() v5
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hannes@saeurebad.de, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, stable@kernel.org
In-Reply-To: <20080715132203.a9482685.akpm@linux-foundation.org>
References: <20080704160737.750988999@saeurebad.de>
	 <1216148794.25942.11.camel@nimitz>
	 <20080715132203.a9482685.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 16 Jul 2008 14:51:40 -0700
Message-Id: <1216245100.8711.8.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 13:22 -0700, Andrew Morton wrote:
> 
> > The sections are 512MB, and you can see 6 valid ones
> > followed by two holes, and then two more valid ones.
> > 
> > Anyway, I believe this patch will fix the oops.
> 
> This looks like it might be suitable.  Can you please test it?

I compiled, tested, and booted on the machine that had this problem.  It
hasn't reappeared.

-- Dave

