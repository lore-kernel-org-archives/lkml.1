Return-Path: <linux-kernel-owner+w=401wt.eu-S1753817AbYH0CQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbYH0CQ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 22:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbYH0CQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 22:16:18 -0400
Received: from qb-out-0506.google.com ([72.14.204.225]:16025 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbYH0CQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 22:16:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IKpLc37nNJyKzYkuFunM9Xt9B/7XxRcepeyhTSr0AE8imT0WdbhuyzLxzScPigXhg7
         t6AWjJ9n6QDmsHkQiuNl6Upu+995gJh5ldH5mZst8tAbFajaLV0HyrjZ4oqOjSVDjxg8
         pRM98HSC9CNtfTEDCYQwvHa8MmJab1bdOuG6M=
Message-ID: <f7848160808261916x6e2a3abfj2c28fa665da792b4@mail.gmail.com>
Date: Tue, 26 Aug 2008 22:16:16 -0400
From: "Parag Warudkar" <parag.lkml@gmail.com>
To: "Greg Ungerer" <gerg@snapgear.com>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Adrian Bunk" <bunk@stusta.de>, "Rusty Russell" <rusty@rustcorp.com.au>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       "Ingo Molnar" <mingo@elte.hu>, linux-embedded@vger.kernel.org
In-Reply-To: <48B4AE68.4040205@snapgear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
	 <20080826183051.GB10925@cs181140183.pp.htv.fi>
	 <alpine.LFD.1.10.0808261144510.3363@nehalem.linux-foundation.org>
	 <20080826205916.GB11734@cs181140183.pp.htv.fi>
	 <alpine.LFD.1.10.0808261403360.3363@nehalem.linux-foundation.org>
	 <f7848160808261554j2f4eaaa6i1ee8801ae75ca7bf@mail.gmail.com>
	 <alpine.LFD.1.10.0808261644260.3363@nehalem.linux-foundation.org>
	 <48B4A577.3020303@snapgear.com>
	 <f7848160808261808p3391c99ekfa1d8991bbf73c10@mail.gmail.com>
	 <48B4AE68.4040205@snapgear.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 9:31 PM, Greg Ungerer <gerg@snapgear.com> wrote:

>
> And the pressure will still be on in _real_ products to reduce
> the RAM footprint as much as possible. There are exceptions but
> generally less is cheaper. Simple economics really.

Well, sure  - but the industry as a whole seems to have gone the other
way - do more with more at the similar or lower price points!
By that definition of less is better we should try and make the kernel
memory pageable (or has someone already done that?) - Windows does it,
by default ;)

Parag
