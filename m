Return-Path: <linux-kernel-owner+w=401wt.eu-S1755577AbYAQURS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbYAQURS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 15:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbYAQURA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 15:17:00 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:12071 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbYAQUQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 15:16:59 -0500
From: Chris mason <chris.mason@oracle.com>
To: "Daniel Phillips" <phillips@google.com>
Subject: Re: [Btrfs-devel] [ANNOUNCE] Btrfs v0.10 (online growing/shrinking, ext3 conversion, and more)
Date: Thu, 17 Jan 2008 15:14:41 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: btrfs-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
References: <20080115105238.4fc3e992@think.oraclecorp.com> <200801171325.55406.chris.mason@oracle.com> <4d47a5d10801171128t371fb3c4y27401c156f20569@mail.gmail.com>
In-Reply-To: <4d47a5d10801171128t371fb3c4y27401c156f20569@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801171514.41963.chris.mason@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 January 2008, Daniel Phillips wrote:
> On Jan 17, 2008 1:25 PM, Chris mason <chris.mason@oracle.com> wrote:
> > So, I've put v0.11 out there.  It fixes those two problems and will also
> > compile on older (2.6.18) enterprise kernels.
> >
> > v0.11 does not have any disk format changes.
>
> Hi Chris,
>
> First, massive congratulations for bringing this to fruition in such a
> short time.
>
> Now back to the regular carping: why even support older kernels?

The general answer is the backports are small and easy.  I don't test them 
heavily, and I don't go out of my way to make things work. 

But, they do make it easier for people to try out, and to figure how to use 
all these new features to solve problems.  Small changes that enable more 
testers are always welcome.

In general, the core parts of the kernel that btrfs uses haven't had many 
interface changes since 2.6.18, so this isn't a huge deal.

-chris
