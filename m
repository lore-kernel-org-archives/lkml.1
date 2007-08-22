Return-Path: <linux-kernel-owner+w=401wt.eu-S1756961AbXHVGwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961AbXHVGwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 02:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbXHVGwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 02:52:24 -0400
Received: from ozlabs.org ([203.10.76.45]:56682 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753222AbXHVGwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 02:52:23 -0400
Subject: Re: [Lguest] [PATCH] turn err into errx in lguest call sites
From: Rusty Russell <rusty@rustcorp.com.au>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, rusty@rustycorp.com.au,
       akpm@linux-foundation.org, ak@suse.de, lguest@ozlabs.org
In-Reply-To: <1187728117715-git-send-email-gcosta@redhat.com>
References: <1187728117715-git-send-email-gcosta@redhat.com>
Content-Type: text/plain
Date: Wed, 22 Aug 2007 16:51:43 +1000
Message-Id: <1187765503.6174.58.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-21 at 17:28 -0300, Glauber de Oliveira Costa wrote:
> These two callsites should really be errx instead of err, since there is
> no errno associated with them in the moment they are issued.
> 
> Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>

Thanks, applied!

Rusty.


