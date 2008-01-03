Return-Path: <linux-kernel-owner+w=401wt.eu-S1753176AbYACOuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbYACOuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 09:50:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751579AbYACOum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 09:50:42 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:57963 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbYACOul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 09:50:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=PIm4yQ19lu5xG0feaeboTGpDNMbwiyUV20+S0E6JS0AwRmJ7WIBYuhUsTDDa21FZrs2gznAV9iu+RVsOPDyf/LxQIOwTj056q84iFuUCzLUiq01792j1js7wfQUZR0XD4oeKHanQoQRk/hGsLfTu2Vnqbal1giSScIJGF9wYOvc=
Date: Thu, 3 Jan 2008 17:50:28 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [x86] kernel/audit.c cleanup according to checkpatch.pl
Message-ID: <20080103145028.GH8046@cvg>
References: <20080103111925.GC8046@cvg> <20080103112957.GA14693@lazybastard.org> <20080103140549.GA19363@elte.hu> <1199370550.3697.79.camel@shinybook.infradead.org> <20080103143711.GA29606@elte.hu> <1199371044.3697.80.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199371044.3697.80.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[David Woodhouse - Thu, Jan 03, 2008 at 02:37:24PM +0000]
| 
| On Thu, 2008-01-03 at 15:37 +0100, Ingo Molnar wrote:
| > * David Woodhouse <dwmw2@infradead.org> wrote:
| > 
| > > On Thu, 2008-01-03 at 15:05 +0100, Ingo Molnar wrote:
| > > > not to make a big issue out of this, but when was the last time you 
| > > > tried to grep this way:
| > > > 
| > > >   grep -E "audit_rate_limit=[0-9]+ audit_backlog" */*.c
| > > 
| > > Not precisely that, but I've certainly had greps fail because people 
| > > have split up strings to meet the stupid 80-character "limit".
| > 
| > yes - but if you read my whole reply you'll see that i qualified it:
| > 
| > >> That's pretty much the only grep pattern that would break. People 
| > >> usually grep on the constant portion of the string, so breaking up a 
| > >>                                                       ^^^^^^^^^^^^^
| > >> line along a variable boundary is perfectly okay.
| 
| Yes, you did. But you failed to provide any good reason for actually
| changing it, either. Leave it as it was.
| 
| -- 
| dwmw2
| 

so what i would do now? i could post updated patch *without* that
splitted line, should I?

		- Cyrill -
