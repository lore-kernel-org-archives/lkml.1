Return-Path: <linux-kernel-owner+w=401wt.eu-S1757986AbYG0EJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986AbYG0EJT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 00:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbYG0EJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 00:09:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44762 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbYG0EJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 00:09:10 -0400
Date: Sun, 27 Jul 2008 05:09:08 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Kara <jack@ucw.cz>
Subject: Re: 2.6.26-mmotm-0724 - linux-next.git loses /proc/sys/fs/quota,
	breaks disk quotas
Message-ID: <20080727040908.GX28946@ZenIV.linux.org.uk>
References: <14615.1217125366@turing-police.cc.vt.edu> <20080726202525.3ac3052f.akpm@linux-foundation.org> <21657.1217130229@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21657.1217130229@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2008 at 11:43:49PM -0400, Valdis.Kletnieks@vt.edu wrote:

> > Ah, it seems to be taking a little vacation over in
> > /proc/sys/kernel/.  Curious.
> 
> Wow. I never *thought* to look for it there, and neither did my userspace :)

Wow, indeed...  Very odd, since there shouldn't be any way for that
to end up there.  Off to try and reproduce it...
