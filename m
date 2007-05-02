Return-Path: <linux-kernel-owner+w=401wt.eu-S1767198AbXEBXHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767198AbXEBXHj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 19:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767196AbXEBXHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 19:07:39 -0400
Received: from [212.12.190.4] ([212.12.190.4]:32964 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1767198AbXEBXHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 19:07:36 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Execute in place
Date: Thu, 3 May 2007 02:11:36 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200705030211.36293.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Wed, 2 May 2007, Phillip Susi wrote:
> > Hugh Dickins wrote:
> > > tmpfs doesn't store its stuff in the page cache twice: that's true,
> > > and I didn't mean to imply otherwise.  But tmpfs doesn't contain any
> > > support for rom memory: you'd have to copy from rom to tmpfs to use
> > > it.
> >
> > The question is, when you execute a binary on tmpfs, does its code
> > segment get mapped directly where it's at in the buffer cache, or does
> > it get copied to another page for the executing process?  At least,
> > assuming this is possible due to the vma and file offsets of the segment
> > being aligned.
>
> Its pages are mapped directly into the executing process, without copying.

Thank GOD!  Boy, was I worried there for a second.

Now, if there were only an easy way to make tmpfs persistent?


Thanks!

--
Al

