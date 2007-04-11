Return-Path: <linux-kernel-owner+w=401wt.eu-S1030779AbXDKD6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030779AbXDKD6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 23:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030795AbXDKD6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 23:58:31 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:56823 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1030779AbXDKD63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 23:58:29 -0400
Message-ID: <376263890.06140@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Wed, 11 Apr 2007 11:54:48 +0800
From: WU Fengguang <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Jan Kara <jack@suse.cz>,
       linux-kernel@vger.kernel.org, npiggin@suse.de
Subject: Re: [PATCH] Improve heuristic detecting sequential reads
Message-ID: <20070411035448.GA4724@mail.ustc.edu.cn>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>, Jan Kara <jack@suse.cz>,
	linux-kernel@vger.kernel.org, npiggin@suse.de
References: <20070410155411.GF13445@duck.suse.cz> <p73y7kzj0ss.fsf@bingen.suse.de> <20070410164540.6d10ddd7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070410164540.6d10ddd7.akpm@linux-foundation.org>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2007 at 04:45:40PM -0700, Andrew Morton wrote:
> On 11 Apr 2007 00:56:51 +0200
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > There's a much more complete patchkit for this that gets reposted
> > regularly on l-k. Perhaps it would make sense to test that first?
> 
> adaptive readahead?  Has been in -mm for a year.  Problem is, it is
> _so_ complete that I just don't know how to merge it.  It's huge, and
> only Wu understands it. So it's really rather stuck.

Yeah, it is.

I'll come up with a minimal patch to first simplify the current
readahead algorithm. The code is ready, if ignoring the document ;-)

Wu
