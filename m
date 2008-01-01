Return-Path: <linux-kernel-owner+w=401wt.eu-S1753084AbYAAKJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbYAAKJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 05:09:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbYAAKJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 05:09:31 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:58815 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988AbYAAKJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 05:09:30 -0500
Date: Tue, 1 Jan 2008 11:09:30 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [Patch 0/8] Remove 'TOPDIR' from Makefiles
Message-ID: <20080101100930.GA28913@uranus.ravnborg.org>
References: <20080101071311.GA2496@hacking>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101071311.GA2496@hacking>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 01, 2008 at 03:13:11PM +0800, WANG Cong wrote:
> 
> TOPDIR is obsolete, use srctree or objtree instead.

Glad to see this being done - long overdue.

Most of your patches (if not all) replaces TOPDIR
with objtree but usage of objtree is only
correct when dealing with output files.
Note that objtree != srctree only for O=... builds.

And a few cases should be dealt with differently.
See individual comments.

	Sam
