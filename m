Return-Path: <linux-kernel-owner+w=401wt.eu-S1762713AbXHUROk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762713AbXHUROk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 13:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762074AbXHURO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 13:14:29 -0400
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:33364 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761467AbXHURO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 13:14:28 -0400
Date: Tue, 21 Aug 2007 10:14:23 -0700
To: Peter Staubach <staubach@redhat.com>
Cc: John Stoffel <john@stoffel.org>, linux-kernel@vger.kernel.org
Subject: Re: NFS hang + umount -f: better behaviour requested.
Message-ID: <20070821171423.GQ3956@digitalkingdom.org>
References: <20070820225415.GL3956@digitalkingdom.org> <18123.5699.405125.137517@stoffel.org> <46CB1A78.7040102@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CB1A78.7040102@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Robin Lee Powell <rlpowell@digitalkingdom.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 01:01:44PM -0400, Peter Staubach wrote:
> John Stoffel wrote:
> >Robin> I'm bringing this up again (I know it's been mentioned here
> >Robin> before) because I had been told that NFS support had gotten
> >Robin> better in Linux recently, so I have been (for my $dayjob)
> >Robin> testing the behaviour of NFS (autofs NFS, specifically) under
> >Robin> Linux with hard,intr and using iptables to simulate a hang.
> >
> >So why are you mouting with hard,intr semantics?  At my current
> >SysAdmin job, we mount everything (solaris included) with
> >'soft,intr' and it works well.  If an NFS server goes down,
> >clients don't hang for large periods of time. 
> 
> Wow!  That's _really_ a bad idea.  NFS READ operations which
> timeout can lead to executables which mysteriously fail, file
> corruption, etc.  NFS WRITE operations which fail may or may not
> lead to file corruption.
> 
> Anything writable should _always_ be mounted "hard" for safety
> purposes.  Readonly mounted file systems _may_ be mounted "soft",
> depending upon what is located on them.

Does write + tcp make this any different?

-Robin

-- 
http://www.digitalkingdom.org/~rlpowell/ *** http://www.lojban.org/
Reason #237 To Learn Lojban: "Homonyms: Their Grate!"
Proud Supporter of the Singularity Institute - http://singinst.org/
