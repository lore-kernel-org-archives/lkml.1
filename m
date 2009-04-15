Return-Path: <linux-kernel-owner+w=401wt.eu-S1756349AbZDOUYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349AbZDOUYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 16:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbZDOUYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 16:24:00 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:34816 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753635AbZDOUYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 16:24:00 -0400
Subject: Re: CAP_SYS_ADMIN on restart(2) (was: Re: [PATCH 00/30] C/R
	OpenVZ/Virtuozzo style)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       hch@infradead.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, mingo@elte.hu
In-Reply-To: <20090415192150.GC26994@x200.localdomain>
References: <20090410023207.GA27788@x200.localdomain>
	 <1239340031.24083.21.camel@nimitz>
	 <20090413091423.GA19236@x200.localdomain>
	 <49E4108A.8050201@cs.columbia.edu>
	 <20090414145830.GA27461@x200.localdomain>
	 <49E4D115.5080601@cs.columbia.edu>
	 <20090414204912.GA28458@x200.localdomain>
	 <20090414213934.GB17986@us.ibm.com>
	 <20090415192150.GC26994@x200.localdomain>
Content-Type: text/plain
Date: Wed, 15 Apr 2009 13:23:53 -0700
Message-Id: <1239827033.32604.167.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-15 at 23:21 +0400, Alexey Dobriyan wrote:
> Is sysctl to control CAP_SYS_ADMIN on restart(2) OK?

If the point is not to let users even *try* restarting things if it
*might* not work, then I guess this might be reasonable.  

If the goal is to increase security by always requiring CAP_SYS_ADMIN
for "dangerous" operations, I fear it will be harmful.  We may have
people adding features that are not considering the security impact of
what they're doing just because the cases they care about all require
privilege.

What would the goal be?

-- Dave

