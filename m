Return-Path: <linux-kernel-owner+w=401wt.eu-S1759727AbYBKXER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759727AbYBKXER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 18:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbYBKXED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 18:04:03 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:43620 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbYBKXEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 18:04:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=r/QAETY4i7CZTuVXQb3wQ4DEnYiGQSy8l3RBtMw9xD8x+4wZSJRMDKVg+/Y6d1I1IXsiU7LnL3SXVDlv4gOt1RIJA2/XuVmtlPFtfzGaW/sbZeHBCfJMe/mTCC2k5SJ1pv9RuZQvx5XYDE4ws3i3M8Qh35vZuvo1rVC0celnRe8=
Date: Tue, 12 Feb 2008 02:03:51 +0300
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] RTTIME watchdog timer proc interface
Message-ID: <20080211230351.GA2270@martell.zuzino.mipt.ru>
References: <47B0C1D4.5080808@ct.jp.nec.com> <1202766767.6247.16.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202766767.6247.16.camel@lappy>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 10:52:47PM +0100, Peter Zijlstra wrote:
> 
> On Mon, 2008-02-11 at 13:44 -0800, Hiroshi Shimamoto wrote:
> > Hi Ingo,
> > 
> > I think an interface to access RLIMIT_RTTIME from outside is useful.
> > It makes administrator able to set RLIMIT_RTTIME watchdog to existing
> > real-time applications without impact.
> > 
> > I implemented that interface with /proc filesystem.
> 
> /proc/<pid>/tasks/<tid>/rttime might also make sense.

As well as /proc/*/limits for all kinds of rlimit stuff.
