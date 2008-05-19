Return-Path: <linux-kernel-owner+w=401wt.eu-S1761838AbYESNkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761838AbYESNkD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:40:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764028AbYESN3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:29:21 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:44291 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764015AbYESN3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:29:18 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Mon, 19 May 2008 09:26:41 -0400
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       jamie@shareable.org
References: <482DDA56.6000301@redhat.com> <20080516130545.845a3be9.akpm@linux-foundation.org> <87ej7zcrqv.fsf@basil.nowhere.org>
In-Reply-To: <87ej7zcrqv.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805190926.41970.chris.mason@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 May 2008, Andi Kleen wrote:
> Andrew Morton <akpm@linux-foundation.org> writes:
> > On Fri, 16 May 2008 14:02:46 -0500
> >
> > Eric Sandeen <sandeen@redhat.com> wrote:
> >> A collection of patches to make ext3 & 4 use barriers by
> >> default, and to call blkdev_issue_flush on fsync if they
> >> are enabled.
> >
> > Last time this came up lots of workloads slowed down by 30% so I
> > dropped the patches in horror.
>
> Didn't ext4 have some new checksum trick to avoid them?

I didn't think checksumming avoided barriers completely.  Just the barrier 
before the commit block, not the barrier after.

-chris
