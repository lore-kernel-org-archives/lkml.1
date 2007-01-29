Return-Path: <linux-kernel-owner+w=401wt.eu-S932758AbXA2K6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932758AbXA2K6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 05:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932921AbXA2K6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 05:58:22 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:43260 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932834AbXA2K6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 05:58:21 -0500
Date: Mon, 29 Jan 2007 14:05:09 +0300
From: Alexey Dobriyan <adobriyan@openvz.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Andrew Morton <akpm@osdl.org>, devel@openvz.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] lutimesat: actual syscall and wire-up on i386
Message-ID: <20070129110509.GA13096@localhost.sw.ru>
References: <20070126112345.GC11128@localhost.sw.ru> <20070126123903.046aaa5e.akpm@osdl.org> <45BA6860.6040007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45BA6860.6040007@redhat.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 26, 2007 at 12:45:20PM -0800, Ulrich Drepper wrote:
> Andrew Morton wrote:
> > OK, but I don't recall having seeing a demand for lutimes().  Opinions
> > are sought?
>
> It's an interface which has been available on other platforms forever
> (lutimes, not lutimesat).  If it can be implemented correctly on the
> interesting file systems I'd say "go ahead", it can only be useful and
> have more benefits than the probably small cost of implementing it.
>
> If on the other hand important filesystems cannot support lutimes then
> I'd wait with introducing the syscall at least until the support is
> added.

What do you mean by "filesystems cannot support lutimes"? Filesystems
that don't have on-disk timestamps for symlinks?

