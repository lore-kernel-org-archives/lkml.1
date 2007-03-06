Return-Path: <linux-kernel-owner+w=401wt.eu-S1030283AbXCFSv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030283AbXCFSv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:51:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030285AbXCFSv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:51:28 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030283AbXCFSv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:51:27 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0703061040260.5963@woody.linux-foundation.org> 
References: <Pine.LNX.4.64.0703061040260.5963@woody.linux-foundation.org>  <20070306173929.2708.37191.stgit@warthog.cambridge.redhat.com> 
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, johannes@sipsolutions.net
Subject: Re: [PATCH] Fix get_order() 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Tue, 06 Mar 2007 18:51:13 +0000
Message-ID: <11544.1173207073@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> That seems bogus. "n == 1" should give "0", no?

Sigh.  No.  The comment header says it all:

	/**
	 * roundup_pow_of_two - round the given value up to nearest power of two
	 * @n - parameter
	 *
	 * round the given value up to the nearest power of two
	 * - the result is undefined when n == 0
	 * - this can be used to initialise global variables from constant data
	 */

Ie: round, say, 30 up to 32, not 5.

David
