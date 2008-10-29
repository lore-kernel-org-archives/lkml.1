Return-Path: <linux-kernel-owner+w=401wt.eu-S1754852AbYJ2VRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbYJ2VRR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 17:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbYJ2VRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 17:17:04 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:33035 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbYJ2VRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 17:17:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PlwN9wU5lx2eNUs5LhKvoajC/DjUV27TC6Y4zD92jt1M5BjMZ+gQI7/77fXvNnOILb
         VLoL0u9lcbIxzsl13Z170Cr9eY0hY1U7lZyrah9Y6+vOb/vgfNv7NikKIHOx3lUnLZ+Z
         ZGNy17An1crn1gg44Y5vWWN1m1C40y+V13mio=
Date: Wed, 29 Oct 2008 22:16:29 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <willy@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Rename DECLARE_MUTEX to DEFINE_SEMAPHORE
Message-ID: <20081029210149.GA6820@joi>
References: <20081026120609.GA10728@joi> <20081026164118.GA19812@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081026164118.GA19812@infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2008 at 12:41:18PM -0400, Christoph Hellwig wrote:
> On Sun, Oct 26, 2008 at 01:06:14PM +0100, Marcin Slusarz wrote:
> > DECLARE_MUTEX is doubly misleading name (it actually _defines_ struct
> > _semaphore_ initialized to 1) and it can be confused with DEFINE_MUTEX
> > (which defines real struct mutex). Rename it.
> 
> NACK.  It describes reasonably well what it does.  Of course that's a
> little confusing as we now have a specialized primitive to just do that.
> 
> If the name annoys you enough so that you want to get rid of it help
> converting the remaining instances to struct mutex and DEFINE_MUTEX().

Changing the name of DECLARE_MUTEX (to something which tells us what it really
does) will increase visibility of semaphore uses, don't you think?
And more visibility means more patches removing its uses.

Marcin
