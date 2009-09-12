Return-Path: <linux-kernel-owner+w=401wt.eu-S1757288AbZILDpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbZILDpg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 23:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbZILDpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 23:45:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:55171 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbZILDpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 23:45:34 -0400
Date: Sat, 12 Sep 2009 05:49:06 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       jakub@redhat.com, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/2] UNREACHABLE() macro
Message-ID: <20090912054906.22b05848@infradead.org>
In-Reply-To: <20090911215525.12B366A98F@magilla.sf.frob.com>
References: <20090910015923.8FB628AE5F@magilla.sf.frob.com>
	<20090910020031.87DC68BF6E@magilla.sf.frob.com>
	<20090911134528.cd1782d9.akpm@linux-foundation.org>
	<20090911215525.12B366A98F@magilla.sf.frob.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Sep 2009 14:55:25 -0700 (PDT)
Roland McGrath <roland@redhat.com> wrote:

> > That's a bit of a mouthful.  Did you consider a runtime probe with
> > scripts/Kbuild.include's try-run, cc-option, etc?  
> 
> I did not see any precedent in the sources for using those to test for
> features by compiling particular test sources (i.e. in autoconf

look at the stackprotector flags.. they work this way already.
It gets done once per kernel build...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
