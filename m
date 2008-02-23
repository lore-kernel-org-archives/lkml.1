Return-Path: <linux-kernel-owner+w=401wt.eu-S1761949AbYBWUCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761949AbYBWUCS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 15:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbYBWUCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 15:02:11 -0500
Received: from smtp-out.google.com ([216.239.45.13]:35619 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbYBWUCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 15:02:10 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=QES3bDzSruXalrm5aY2tStjoHTD/l9ugMv5ic62oOh+5pBIO9VByt0Z09OTQHPtIm
	LTRrGL+kHV8wH1JiCiZfg==
Message-ID: <6599ad830802231202q6584557fte44f4976eacc6e89@mail.gmail.com>
Date: Sat, 23 Feb 2008 12:02:06 -0800
From: "Paul Menage" <menage@google.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 3/8] sched: rt-group: interface
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       tong.n.li@intel.com
In-Reply-To: <1203796668.6242.82.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080204210258.118479000@chello.nl>
	 <20080204211836.968632000@chello.nl>
	 <6599ad830802231148w518d937cyd75d1d0a35702d9d@mail.gmail.com>
	 <1203796668.6242.82.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 11:57 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>  > If so, could we avoid that problem by using 0 rather than -1 as the
>  > "unlimited" value? It looks from what I've read in the Documentation
>  > changes as though 0 isn't really a meaningful value.
>
>  0 means no time, quite useful and clearly distinct from inf. time.
>

So a real-time task in a cgroup with a 0 rt_runtime can be in the R
state but never actually get to run? OK, if people need to be able to
do that then fair enough.

In that case I guess I'll have to add signed versions of the
read_uint/write_uint methods.

Paul
