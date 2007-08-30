Return-Path: <linux-kernel-owner+w=401wt.eu-S1763473AbXH3WXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763473AbXH3WXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 18:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758635AbXH3WXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 18:23:14 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:54930
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757668AbXH3WXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 18:23:13 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] sysctl: Deprecate sys_sysctl in a user space visible fashion.
Date: Thu, 30 Aug 2007 18:22:47 -0500
User-Agent: KMail/1.9.6
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <m1veazb7w0.fsf@ebiederm.dsl.xmission.com> <200708301432.11516.rob@landley.net> <20070830183402.GA17084@infradead.org>
In-Reply-To: <20070830183402.GA17084@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708301822.47594.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 August 2007 1:34:02 pm Christoph Hellwig wrote:
> On Thu, Aug 30, 2007 at 02:32:11PM -0500, Rob Landley wrote:
> > (If sysctlfs wasn't part of proc, that would be less of an issue, but we
> > need union mounts for that...)
>
> Not at all.  all sysctls are under /proc/sys/

Ah, right.  Good point.  (I was thinking of the problem of 
splitting /proc/$PID directories from the rest of the stuff in /proc.)

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
