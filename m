Return-Path: <linux-kernel-owner+w=401wt.eu-S1765545AbYETMHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765545AbYETMHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 08:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950AbYETMGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 08:06:53 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:28078 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbYETMGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 08:06:52 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Timothy Shimmin <tes@sgi.com>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Tue, 20 May 2008 08:04:48 -0400
User-Agent: KMail/1.9.9
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Eric Sandeen <sandeen@redhat.com>, Theodore Tso <tytso@mit.edu>,
       Andi Kleen <andi@firstfloor.org>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <482DDA56.6000301@redhat.com> <200805192029.21688.chris.mason@oracle.com> <48324598.4060803@sgi.com>
In-Reply-To: <48324598.4060803@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805200804.49389.chris.mason@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 May 2008, Timothy Shimmin wrote:

[ power fail testing with write back cache on ]

> > I was also able to trigger corruptions on XFS (one run out of two), so it
> > is unlikely I'm seeing bugs in the ext3 replay or logging code.
>
> Just to clarify,
> was this test with barriers on or off for XFS?
> I'm wondering if it was with barriers on, then we have a reproducible
> bug in log replay.
> Or whether you were just confirming the problems with barriers off on
> another filesystem.

Barriers were off on xfs, the corruptions were not xfs' fault.

-chris
