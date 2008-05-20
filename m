Return-Path: <linux-kernel-owner+w=401wt.eu-S1764384AbYETXsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764384AbYETXsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 19:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbYETXsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 19:48:43 -0400
Received: from mail2.shareable.org ([80.68.89.115]:36553 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561AbYETXsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 19:48:42 -0400
Date: Wed, 21 May 2008 00:48:20 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Ric Wheeler <ricwheeler@gmail.com>
Cc: Theodore Tso <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Message-ID: <20080520234820.GM27853@shareable.org>
References: <482DDA56.6000301@redhat.com> <20080517002030.GA7374@mit.edu> <20080516173552.e88183d9.akpm@linux-foundation.org> <200805172048.34455.chris.mason@oracle.com> <20080518013641.GH16496@mit.edu> <4830420D.4080608@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4830420D.4080608@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ric Wheeler wrote:
> The hard thing is to figure out how to test this kind of scenario 
> without dropping power.

Apart from using virtual machines, you mean?

> To expose the failure mode, it might be 
> sufficient to drop power to a drive with smartctl (or, if you have hot 
> swap bays, just pull them).

I wonder, does sending any kind of reset commands to drives cause them
to discard their write cache?

If the hot swap power switch is accessible from software, that would
be a nice trick :-)

-- Jamie
