Return-Path: <linux-kernel-owner+w=401wt.eu-S1756578AbZDVUhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbZDVUhI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 16:37:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754288AbZDVUg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 16:36:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46301 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbZDVUg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 16:36:56 -0400
Date: Wed, 22 Apr 2009 22:40:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <andi@firstfloor.org>, joseph.cihula@intel.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
       chrisw@sous-sol.org, jmorris@namei.org, jbeulich@novell.com,
       peterm@redhat.com, gang.wei@intel.com, shane.wang@intel.com
Subject: Re: [RFC v2][PATCH 1/1] intel_txt: Intel(R) TXT and tboot kernel support
Message-ID: <20090422204028.GC13896@one.firstfloor.org>
References: <49D1A6AB.5090808@intel.com> <87d4baqnxy.fsf@basil.nowhere.org> <49EF7E85.7040104@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EF7E85.7040104@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 01:31:01PM -0700, Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
> >This means it explodes with paravirt, right? Do you have a check early
> >for that?
> >  
> 
> The tboot stuff should only be run on bare hardware; if there's 
> virtualization under the kernel, then TXT should be happening at that level.

Yes I know, but still this should be enforced.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
