Return-Path: <linux-kernel-owner+w=401wt.eu-S965485AbXC0V3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965485AbXC0V3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 17:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965483AbXC0V3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 17:29:19 -0400
Received: from ns1.suse.de ([195.135.220.2]:54763 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965480AbXC0V3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 17:29:19 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: discuss@x86-64.org
Subject: Re: [discuss] 2.6.21-rc5-mm1: i386/x86_64 register_die_notifier() change
Date: Tue, 27 Mar 2007 23:29:13 +0200
User-Agent: KMail/1.9.5
Cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20070326205706.a750bb35.akpm@linux-foundation.org> <20070327212605.GE16477@stusta.de>
In-Reply-To: <20070327212605.GE16477@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703272329.13779.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 March 2007 23:26, Adrian Bunk wrote:
> On Mon, Mar 26, 2007 at 08:57:06PM -0800, Andrew Morton wrote:
> >...
> > Changes since 2.6.21-rc4-mm1:
> >...
> > +move-die-notifier-handling-to-common-code.patch
> >...
> >  Misc
> >...
> 
> Is the removal of the vmalloc_sync_all() call in register_die_notifier() 
> on i386 and x86_64 both intentional and correct?

It's wrong. The die notifier is used by NMIs and that needs vmalloc_sync_all()

Thanks for catching that.


-Andi
