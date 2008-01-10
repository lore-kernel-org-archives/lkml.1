Return-Path: <linux-kernel-owner+w=401wt.eu-S1758924AbYAJN1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924AbYAJN1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 08:27:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbYAJN1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 08:27:32 -0500
Received: from [212.12.190.45] ([212.12.190.45]:52104 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754411AbYAJN1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 08:27:32 -0500
From: Al Boldi <a1426z@gawab.com>
To: linux-fsdevel@vger.kernel.org
Subject: Re: [RFD] Incremental fsck
Date: Thu, 10 Jan 2008 16:26:53 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
References: <200801090022.55589.a1426z@gawab.com> <200801091452.14890.a1426z@gawab.com> <20080109094412.73f3249c@cuia.boston.redhat.com>
In-Reply-To: <20080109094412.73f3249c@cuia.boston.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801101626.53315.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> Al Boldi <a1426z@gawab.com> wrote:
> > Ok, but let's look at this a bit more opportunistic / optimistic.
>
> You can't play fast and loose with data integrity.

Correct, but you have to be realistic...

> Besides, if we looked at things optimistically, we would conclude
> that no fsck will be needed,

And that's the reality, because people are mostly optimistic and feel 
extremely tempted to just force-mount a dirty ext3fs, instead of waiting 
hours-on-end for a complete fsck, which mostly comes back with some benign 
"inode should be zero" warning.

> ever :)

Well not ever, but most people probably fsck during scheduled shutdowns, or 
when they are forced to, due to online fs accessibility errors.

> > > http://infohost.nmt.edu/~val/review/chunkfs.pdf
>
> You will really want to read this paper, if you haven't already.

Definitely a good read, but attacking the problem from a completely different 
POV.

BTW:  Dropped some cc's due to bounces.


Thanks!

--
Al

