Return-Path: <linux-kernel-owner+w=401wt.eu-S932909AbYDVUsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932909AbYDVUsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 16:48:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762881AbYDVUrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 16:47:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45554 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762876AbYDVUro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 16:47:44 -0400
Date: Tue, 22 Apr 2008 13:46:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Teigland <teigland@redhat.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] dlm updates for 2.6.26
In-Reply-To: <20080422135116.GA14594@redhat.com>
Message-ID: <alpine.LFD.1.10.0804221344470.2779@woody.linux-foundation.org>
References: <20080422135116.GA14594@redhat.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 22 Apr 2008, David Teigland wrote:
> 
> Please pull dlm updates for 2.6.26 from:

Small detail: can you please use "--stat --summary -M" to generate the 
diffstat, because you had:

>  ...
>  21 files changed, 614 insertions(+), 499 deletions(-)

but what I then check against notices the rename, and becomes:

 ...
 20 files changed, 276 insertions(+), 161 deletions(-)
 rename fs/{gfs2/locking => }/dlm/plock.c (67%)
 create mode 100644 include/linux/dlm_plock.h
 delete mode 100644 include/linux/lock_dlm_plock.h

which I think is more accurate as to how big the changes were, as well as 
just more human-readable and informative.

(Apparently the naming changes in lock_dlm_plock.h -> dlm_plock.h makes it 
be effectively a rewrite, explaining why it's not two renames..)

		Linus
