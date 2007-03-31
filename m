Return-Path: <linux-kernel-owner+w=401wt.eu-S1753108AbXCaORa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbXCaORa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 10:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbXCaORa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 10:17:30 -0400
Received: from smtp009.mail.ukl.yahoo.com ([217.12.11.63]:26656 "HELO
	smtp009.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753108AbXCaORM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 10:17:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=jvJa3YpS3KOzEkeVMFCuDJmltpbz+DqQEaM2ZFdZ7qcxyuflxbIPVq1nJJfQb8Vu4QFC25/fyW+P+59y8YMw3rrq1knT1CGTearwL9lLNfUPwOe64nLvOYrFlQ9zN71F4fRHyT+385OOdeiUCVBTNQLTauSuAATjBOt6O9FV9PE=  ;
X-YMail-OSG: Fg2_U0sVM1lfOS9Fh8klpKxr7Xo8xGLv4iCdGkh3bVp3DyZiYpKF.3mtJ4hfULXrPMJhn4m0diuAnQGgxuWiSibXlsUgtjLBG.G890KWYfoTGaAC
From: Blaisorblade <blaisorblade@yahoo.it>
To: Jeff Dike <jdike@addtoit.com>
Subject: Re: [uml-devel] [PATCH] UML - fix I/O hang when multiple devices are in use
Date: Sat, 31 Mar 2007 16:17:08 +0200
User-Agent: KMail/1.9.6
Cc: user-mode-linux-devel@lists.sourceforge.net, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <20070328020247.GA12299@c2.user-mode-linux.org> <200703290236.44324.blaisorblade@yahoo.it> <20070329182920.GB8065@c2.user-mode-linux.org>
In-Reply-To: <20070329182920.GB8065@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703311617.09082.blaisorblade@yahoo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On giovedì 29 marzo 2007, Jeff Dike wrote:
> On Thu, Mar 29, 2007 at 02:36:43AM +0200, Blaisorblade wrote:
> > > Sometimes you need to. I'd probably just remove the do_ubd check and
> > > always recall the request function when handling completions, it's
> > > easier and safe.
>
> If I'm understanding this correctly, this is what happens now.  There
> is still the flag check and return if the queue is being run, but I
> don't see the advantage of removing that.
Possibly he just didn't understood what do_ubd was for, maybe there's some 
technical reason.

> That's a lot of mapping and unmapping though.  I wonder if just
> calling mmap would cause the COWed page to be dropped...
Yes, it would.
-- 
Inform me of my mistakes, so I can add them to my list!
Paolo Giarrusso, aka Blaisorblade
http://www.user-mode-linux.org/~blaisorblade
