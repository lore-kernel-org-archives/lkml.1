Return-Path: <linux-kernel-owner+w=401wt.eu-S1757134AbZC1Ghh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757134AbZC1Ghh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 02:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753673AbZC1Gh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 02:37:27 -0400
Received: from ozlabs.org ([203.10.76.45]:58007 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870AbZC1Gh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 02:37:27 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 3/5] lguest: avoid accidental recycling of pgdir pages
Date: Sat, 28 Mar 2009 17:07:22 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: lguest@ozlabs.org, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <200903271022.28863.rusty@rustcorp.com.au> <200903271154.22450.rusty@rustcorp.com.au> <49CCFFC0.1020904@goop.org>
In-Reply-To: <49CCFFC0.1020904@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903281707.22688.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 March 2009 03:03:04 Jeremy Fitzhardinge wrote:
> Rusty Russell wrote:
> > Now, I haven't *seen* this happen...
> >   
> 
> Oh, maybe its because you already zap the shadows on tlb flush, and the 
> kernel is careful to tlb flush every pagetable page before freeing...

OK, you've convinced me.  I'll drop this patch.  It was as I was looking for
the inconsistent pte values that I thought of this issue.

Thanks!
Rusty.
