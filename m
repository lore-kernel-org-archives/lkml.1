Return-Path: <linux-kernel-owner+w=401wt.eu-S1756516AbZA2Iji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbZA2Iji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 03:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbZA2Ij1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 03:39:27 -0500
Received: from ozlabs.org ([203.10.76.45]:33103 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbZA2Ij0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 03:39:26 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 3 of 7] x86: fix paravirt clobber in entry_64.S
Date: Thu, 29 Jan 2009 19:09:18 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Xen-devel" <xen-devel@lists.xensource.com>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Zachary Amsden <zach@vmware.com>,
       Ravikiran Thirumalai <kiran@scalemp.com>
References: <patchbomb.1233182100@abulafia.goop.org> <138b9e1650b385d5ac9d.1233182103@abulafia.goop.org>
In-Reply-To: <138b9e1650b385d5ac9d.1233182103@abulafia.goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901291909.18929.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 January 2009 09:05:03 Jeremy Fitzhardinge wrote:
> The clobber is trying to say that anything except RDI is available for
> clobbering, but actually clobbers everything.  This hasn't mattered
> because the clobbers were basically ignored, but subsequent patches
> will rely on them.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Hmm, did we never have the deliberate-clobbering debug code for 64 bit?

Thanks,
Rusty.
