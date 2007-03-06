Return-Path: <linux-kernel-owner+w=401wt.eu-S965991AbXCFSjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965991AbXCFSjE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:39:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965993AbXCFSjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:39:04 -0500
Received: from terminus.zytor.com ([192.83.249.54]:37374 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965991AbXCFSjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:39:01 -0500
Message-ID: <45EDB4D2.5080702@zytor.com>
Date: Tue, 06 Mar 2007 10:37:06 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: torvalds@osdl.org, akpm@osdl.org, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH] Fix get_order() [try #2]
References: <20070306183426.10768.51800.stgit@warthog.cambridge.redhat.com>
In-Reply-To: <20070306183426.10768.51800.stgit@warthog.cambridge.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> From: David Howells <dhowells@redhat.com>
> 
> Provide an ilog2_up() that rounds its result up (ilog2() rounds down).
> 
> Fix get_order() to use ilog2_up() not ilog2() to get the correct rounding.
> 
> Adjust the documentation surrounding ilog2() and co. to indicate what rounding
> they perform.
> 
> Fix roundup_pow_of_two(1) to give 1, not 0.

Eh? roundup_pow_of_two(1) should be 0; 2^0 = 1.

	-hpa
