Return-Path: <linux-kernel-owner+w=401wt.eu-S1757195AbYFQRed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195AbYFQRed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 13:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754931AbYFQReV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 13:34:21 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:34002
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386AbYFQReO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 13:34:14 -0400
Date: Tue, 17 Jun 2008 19:34:11 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Valdis.Kletnieks@vt.edu
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>,
       Ivana Varekova <varekova@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org
Subject: Re: PR_SET_SECCOMP and PR_GET_SECCOMP doc (and bug?)
Message-ID: <20080617173411.GC28087@duo.random>
References: <48565951.40603@gmail.com> <20080616162543.GA9552@duo.random> <cfd18e0f0806170632p27a5ccd2obadaf0dfd4ce64aa@mail.gmail.com> <18697.1213719134@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18697.1213719134@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2008 at 12:12:14PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 17 Jun 2008 15:32:29 +0200, Michael Kerrisk said:
> > On Mon, Jun 16, 2008 at 6:25 PM, Andrea Arcangeli <andrea@qumranet.com> wrote:
> > > On Mon, Jun 16, 2008 at 02:15:13PM +0200, Michael Kerrisk wrote:
> 
> > >>     PR_GET_SECCOMP (since Linux 2.6.23)
> > >>         Return the secure computing mode  of  the  calling  thread.
> > >>         Not  very  useful: if the caller is not in secure computing
> > >>         mode, this operation returns 0; if the caller is in  secure
> > >>         computing  mode, then the prctl() call will cause a SIGKILL
> > >>         signal to be sent to the process.  This operation  is  only
> > >>         available  if  the kernel is configured with CONFIG_SECCOMP
> > >>         enabled.
> 
> Would it make sense to change the text to read "Not very useful for the
> current implementation of mode=1" and/or add that it may be useful for

Yes, makes sense to me ;).
