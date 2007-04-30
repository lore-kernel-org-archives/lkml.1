Return-Path: <linux-kernel-owner+w=401wt.eu-S1946343AbXD3Q0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946343AbXD3Q0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423624AbXD3Q0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 12:26:21 -0400
Received: from ns2.suse.de ([195.135.220.15]:37673 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946404AbXD3QZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 12:25:33 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 01/12] x86_64: Allow fixmaps to be used with the initial page table.
Date: Mon, 30 Apr 2007 18:23:10 +0200
User-Agent: KMail/1.9.6
Cc: virtualization <virtualization@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
References: <m1d51l6f1y.fsf@ebiederm.dsl.xmission.com> <m18xc96eyq.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m18xc96eyq.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704301823.11150.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 April 2007 17:48:13 Eric W. Biederman wrote:
> 
> This patch preallocates the intermediate page table entries so that
> all that is needed to setup a fixmap is to fill in the appropriate
> pte.
> 
> By doing this modern hardware that uses memory mapped access can be
> talked to early in boot through a fixmap. 

I'll take 1-4 after the .22 merge; a little too experimental right now

-Andi

>
