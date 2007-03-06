Return-Path: <linux-kernel-owner+w=401wt.eu-S966002AbXCFSlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966002AbXCFSlz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966016AbXCFSly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:41:54 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965992AbXCFSls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:41:48 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <45EDB4D2.5080702@zytor.com> 
References: <45EDB4D2.5080702@zytor.com>  <20070306183426.10768.51800.stgit@warthog.cambridge.redhat.com> 
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: torvalds@osdl.org, akpm@osdl.org, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH] Fix get_order() [try #2] 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Tue, 06 Mar 2007 18:41:07 +0000
Message-ID: <11342.1173206467@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin <hpa@zytor.com> wrote:

> Eh? roundup_pow_of_two(1) should be 0; 2^0 = 1.

Nonono.

	roundup_pow_of_two(0)  => ?
	roundup_pow_of_two(1)  => 1
	roundup_pow_of_two(2)  => 2
	roundup_pow_of_two(3)  => 4
	roundup_pow_of_two(4)  => 4
	roundup_pow_of_two(5)  => 8
	roundup_pow_of_two(6)  => 8
	roundup_pow_of_two(7)  => 8
	roundup_pow_of_two(8)  => 8
	roundup_pow_of_two(9)  => 16
	roundup_pow_of_two(10) => 16
	roundup_pow_of_two(11) => 16
	...

David
