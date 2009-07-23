Return-Path: <linux-kernel-owner+w=401wt.eu-S1753866AbZGWTRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbZGWTRg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 15:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753518AbZGWTRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 15:17:36 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60059 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbZGWTRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 15:17:35 -0400
Date: Thu, 23 Jul 2009 21:17:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Sage Weil <sage@newdream.net>
Cc: Andi Kleen <andi@firstfloor.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/19] ceph: address space operations
Message-ID: <20090723191734.GF19207@basil.fritz.box>
References: <1248292313-31326-2-git-send-email-sage@newdream.net> <1248292313-31326-3-git-send-email-sage@newdream.net> <1248292313-31326-4-git-send-email-sage@newdream.net> <1248292313-31326-5-git-send-email-sage@newdream.net> <1248292313-31326-6-git-send-email-sage@newdream.net> <1248292313-31326-7-git-send-email-sage@newdream.net> <1248292313-31326-8-git-send-email-sage@newdream.net> <1248292313-31326-9-git-send-email-sage@newdream.net> <874ot33ddd.fsf@basil.nowhere.org> <Pine.LNX.4.64.0907231115190.2930@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0907231115190.2930@cobra.newdream.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 23, 2009 at 11:22:04AM -0700, Sage Weil wrote:
> I fixed the bad GFP_KERNEL/uncheck kmalloc.  Which was just a struct 
> pagevec, which we added a while ago to reduce stack usage.  Maybe the 
> stack is a better place for it though?  (cifs puts it on the stack...)

Sorry forgot to answer that earlier. I would put it on the stack.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
