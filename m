Return-Path: <linux-kernel-owner+w=401wt.eu-S1754063AbZA1E3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbZA1E3X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 23:29:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbZA1E3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 23:29:14 -0500
Received: from tundra.namei.org ([65.99.196.166]:3063 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874AbZA1E3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 23:29:13 -0500
Date: Wed, 28 Jan 2009 15:29:03 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Casey Schaufler <casey@schaufler-ca.com>
cc: LKLM <linux-kernel@vger.kernel.org>,
       LSM <linux-security-module@vger.kernel.org>,
       "Ahmed S. Darwish" <darwish.07@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] smackfs load append mode fix - resend unmundged.
In-Reply-To: <497FD9CD.1090202@schaufler-ca.com>
Message-ID: <alpine.LRH.1.10.0901281527290.14028@tundra.namei.org>
References: <497FD9CD.1090202@schaufler-ca.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009, Casey Schaufler wrote:

> From: Casey Schaufler <casey@schaufler-ca.com>
> 
> Given just how hard it is to find the code that uses MAY_APPEND
> it's probably not a big surprise that this went unnoticed for so
> long. The Smack rules loading code is incorrectly setting the
> MAY_READ bit when MAY_APPEND is requested.
> 
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

The patch was still corrupt (and you didn't format the subject line 
properly).

A fixed version for Linus may be pulled via:

The following changes since commit e4a7ca29039e615ce13a61b9c6abfb2aa394e9a1:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../gregkh/usb-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6 for-linus

Casey Schaufler (1):
      smack: smackfs load append mode fix

 security/smack/smackfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


-- 
James Morris
<jmorris@namei.org>
