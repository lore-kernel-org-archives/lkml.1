Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbZEDTug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbZEDTug (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 15:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbZEDTu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 15:50:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:45697 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbZEDTu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 15:50:26 -0400
Date: Mon, 4 May 2009 12:51:24 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jake Edge <jake@lwn.net>, security@kernel.org,
       linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
       linux-security-module@vger.kernel.org, Eric Paris <eparis@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Roland McGrath <roland@redhat.com>,
       mingo@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       Greg KH <greg@kroah.com>, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [Security] [PATCH] proc: avoid information leaks to
 non-privileged processes
Message-ID: <20090504125124.0f469970@infradead.org>
In-Reply-To: <alpine.LFD.2.01.0905041159480.4983@localhost.localdomain>
References: <20090504125114.5e391564@chukar>
	<alpine.LFD.2.01.0905041159480.4983@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 May 2009 12:00:12 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Mon, 4 May 2009, Jake Edge wrote:
> >
> > This is essentially v2 of "[PATCH] proc: avoid leaking eip, esp, or
> > wchan to non-privileged processes", adding some of Eric Biederman's
> > suggestions as well as the start_stack change (only give out that
> > address if the process is ptrace()-able).  This has been tested
> > with ps and top without any ill effects being seen.
> 
> Looks sane to me. Anybody objects?
> 

Acked-by: Arjan van de Ven <arjan@linux.intel.com>

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
