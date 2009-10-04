Return-Path: <linux-kernel-owner+w=401wt.eu-S1757476AbZJDQn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476AbZJDQn5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 12:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757386AbZJDQn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 12:43:56 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:36449 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621AbZJDQn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 12:43:56 -0400
Subject: Re: nfs mount breakage as of 8a0382f6f
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4AC8A23A.800@redhat.com>
References: <4AC8A23A.800@redhat.com>
Content-Type: text/plain
Date: Sun, 04 Oct 2009 12:43:15 -0400
Message-Id: <1254674595.4592.1.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 2 msgs/h 1 sum rcpts/h 7 sum msgs/h 2 total rcpts 1595 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 0E0D27E09E12041AFA6138C4B22F5B0CE9145290
X-UiO-SPAM-Test: remote_host: 68.40.207.222 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 300 max/h 6 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-10-04 at 15:25 +0200, Avi Kivity wrote:
> My F11 host switched to automounting nfs v2 instead of v3.  That has 
> unfortunate effects on large files.
> 

It's a known issue (see
http://bugzilla.kernel.org/show_bug.cgi?id=14259).

I'll be merging the fix in http://patchwork.kernel.org/patch/50428/
soon...

Cheers
  Trond

