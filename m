Return-Path: <linux-kernel-owner+w=401wt.eu-S1765630AbXEYVGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765630AbXEYVGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 17:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758219AbXEYVFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 17:05:34 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:42724 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765610AbXEYVFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 17:05:33 -0400
In-Reply-To: <20070522142305.bc3a0aeb.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jfannin@gmail.com (Joseph Fannin), kjhall@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, safford@us.ibm.com, sailer@us.ibm.com,
       serue@us.ibm.com, zohar@us.ibm.com
MIME-Version: 1.0
Subject: Re: 2.6.22-rc1-mm1: evm BUG when reading sysfs file
X-Mailer: Lotus Notes Release 7.0.1P March 16, 2007
Message-ID: <OF3B8BF956.BB6E0AED-ON852572E6.0071D59F-852572E6.003202FD@us.ibm.com>
From: Mimi Zohar <zohar@us.ibm.com>
Date: Fri, 25 May 2007 17:05:34 -0400
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Build V80_M4_03042007|March 04, 2007) at
 05/25/2007 17:05:35,
	Serialize complete at 05/25/2007 17:05:35
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote on 05/22/2007 05:23:05 PM:

> On Tue, 22 May 2007 03:25:48 -0400
> jfannin@gmail.com (Joseph Fannin) wrote:
> 
> >     This comes a bit after IMA bails out successfully, if that's 
relevant:
...
> > 
> > [    1.708761] ima (ima_init): No TPM chip found(rc = -19), activating
> > TPM-bypass!
> 
> OK, thanks.  Does the crash go away if you disable IMA, SLIM, etc in 
.config?
> 
> I think I'll drop all those patches, actually - they don't seem to be 
going
> anywhere.

You are absolutely right, we have been stalled on EVM/IMA/SLIM, while 
trying
to figure out the mtime and revocation issues. In retrospect we tried to 
submit
too much complex code all at once. 

We will resubmit in small functional pieces as the technical issues have 
been
resolved, starting with the LIM API and hooks, which are independent of 
the 
mtime and revocation issues.

Mimi Zohar


