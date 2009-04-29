Return-Path: <linux-kernel-owner+w=401wt.eu-S1753834AbZD2GH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbZD2GH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 02:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbZD2GHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 02:07:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33000 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbZD2GHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 02:07:47 -0400
Date: Wed, 29 Apr 2009 08:11:48 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v2] x86: MCE: Re-implement MCE log ring buffer as per-CPU ring buffer
Message-ID: <20090429061148.GQ27382@one.firstfloor.org>
References: <1240910841.6842.1163.camel@yhuang-dev.sh.intel.com> <87eivdqdsq.fsf@basil.nowhere.org> <1240968709.6842.1175.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240968709.6842.1175.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Maybe the comment is a little confusing. What we do is limit the size of
> user buffer size to prevent system from not response. If the user buffer

Ah. The standard way to handle this is to add cond_resched()s where
appropiate. Maybe that would be an alternative or is that not
possible? You have to drop locks of course.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
