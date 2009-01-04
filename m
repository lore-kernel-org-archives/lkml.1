Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbZADCEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbZADCEA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 21:04:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750988AbZADCDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 21:03:51 -0500
Received: from mail.fieldses.org ([141.211.133.115]:57414 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbZADCDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 21:03:50 -0500
Date: Sat, 3 Jan 2009 21:03:34 -0500
To: David Howells <dhowells@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, jmorris@namei.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] CRED: Fix regression in cap_capable() as shown up by
	sys_faccessat() [ver #2]
Message-ID: <20090104020334.GE24075@fieldses.org>
References: <20090103184921.GB20166@fieldses.org> <20090102051905.GC1073@fieldses.org> <20090101235332.GA31840@fieldses.org> <24959.1230694093@redhat.com> <20081230134248.GA30124@lst.de> <21275.1230736542@redhat.com> <29449.1230859152@redhat.com> <32481.1230897578@redhat.com> <20090102164505.GA10465@fieldses.org> <14883.1231023806@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14883.1231023806@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 03, 2009 at 11:03:26PM +0000, David Howells wrote:
> J. Bruce Fields <bfields@fieldses.org> wrote:
> 
> > More precisely:
> > 	- The last working commit is b6dff3ec... "CRED: Separate task
> > 	  security context from task_struct".
> > 	- The first commit exhibiting the permissions problem is
> > 	  a6f76f2... "CRED: Make execve() take advantage of
> > 	  copy-on-write credentials".
> > 	- The 9 commits in between (from f1752eec to d84f4f9) result in
> > 	  a soft lookup on boot.
> 
> Okay, I'll have a look at that, but did you manage to find out if the patch I
> posted fixed the problem you originally mentioned?

I tested that patch, yes, but it didn't fix the problem.

--b.
