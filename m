Return-Path: <linux-kernel-owner+w=401wt.eu-S1754344AbYJWOOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbYJWOOt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 10:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbYJWOOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 10:14:39 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:54078 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbYJWOOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 10:14:38 -0400
Date: Thu, 23 Oct 2008 15:14:37 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: rdunlap@xenotime.net, jschopp@austin.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: asterisk-slash sequence in quoted string confuses checkpatch.pl
Message-ID: <20081023141437.GE8343@brain>
References: <200810212025.FCC73959.OJVHMOLOFFSQtF@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810212025.FCC73959.OJVHMOLOFFSQtF@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 08:25:09PM +0900, Tetsuo Handa wrote:
> [Reposting since the webmail system broke the code by adding backslashes. ]
> 
> Hello.
> 
> The below code confuses checkpatch.pl ver 0.21.
> 
> Regards.
> ----------
> # cat /tmp/foo.c
> void foo(void)
> {
> 	bar(" /proc/\\*/");
> 	bar(" /proc/\\$/");
> }
> # /usr/src/vanilla/linux-2.6.27.2/scripts/checkpatch.pl --file /tmp/foo.c
> ERROR: need consistent spacing around '/' (ctx:WxV)
> #4: FILE: tmp/foo.c:4:
> +       bar(" /proc/\\$/");

We believe that this is fixed in the latest release, and indeed I believe
you have acked.  But I'll reply again here for completeness.

-apw
