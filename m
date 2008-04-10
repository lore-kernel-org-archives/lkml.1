Return-Path: <linux-kernel-owner+w=401wt.eu-S1759461AbYDJUw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759461AbYDJUw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 16:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757395AbYDJUwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 16:52:20 -0400
Received: from el-out-1112.google.com ([209.85.162.176]:44023 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757394AbYDJUwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 16:52:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=JnN2WCMUZBY4M2Smo7gfGBk9/4LcK2ELUCRLcSnrrUJ61FosluwvTwGPzltOYLziDRBGYBQsFoQg6jPatuGfBXY/JGyLFpcK4dktXTTvsFQLmSrL9IVPPBURxA3GZDamEIizi7O3CgjJZM2UedDHrqTxBeZL5IszgfS4sE3l/38=
Subject: Re: [PATCH] lzo: fix possible typo in decompresor
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Richard Purdie <rpurdie@rpsys.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.00.0804101346240.3143@woody.linux-foundation.org>
References: <1207859903.22001.36.camel@brick>
	 <alpine.LFD.1.00.0804101346240.3143@woody.linux-foundation.org>
Content-Type: text/plain
Date: Thu, 10 Apr 2008 13:52:19 -0700
Message-Id: <1207860739.22001.41.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-04-10 at 13:49 -0700, Linus Torvalds wrote:
> 
> On Thu, 10 Apr 2008, Harvey Harrison wrote:
> >
> > Shift of a le value seems strange, probably meant to shift the cpu-order
> > variable as in the prvious section of the switch statement.
> 
> Hmm. This patch looks ObviouslyCorrect(tm), but it worries me that 
> apparently the old broken code has been around since last July, and afaik 
> it can never have worked on big-endian machines.
> 
> So did nobody ever use it, or why hasn't this ever triggered? How did you 
> find this? A sparse warning?
> 
> 		Linus

When converting in tree users to my proposed unaligned byteswapping api.
See the 8 patch series posted today to linux-arch.

Harvey

