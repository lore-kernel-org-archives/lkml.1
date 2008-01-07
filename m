Return-Path: <linux-kernel-owner+w=401wt.eu-S1759948AbYAGVds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759948AbYAGVds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 16:33:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759359AbYAGVdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 16:33:37 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34580 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759338AbYAGVdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 16:33:36 -0500
Date: Mon, 7 Jan 2008 21:30:54 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: David Miller <davem@davemloft.net>, ebiederm@xmission.com, bcrl@kvack.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: regression: sysctl_check changes in 2.6.24 are O(n) resulting
 in slow creation of 10000 network interfaces
Message-ID: <20080107213054.23270044@lxorguk.ukuu.org.uk>
In-Reply-To: <p73wsqlqsa9.fsf@bingen.suse.de>
References: <20080106220307.GU28570@kvack.org>
	<m1ir26ktqi.fsf@ebiederm.dsl.xmission.com>
	<20080106.231040.222338659.davem@davemloft.net>
	<p73wsqlqsa9.fsf@bingen.suse.de>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think that would be a better option than to complicate sysctl.c
> for this uncommon case.

What is so complicated about hashing the entries if you are checking for
duplicates when debugging. You can set the hash function to "0" and the
array size to 1 when the debug is off and it'll all go away nicely
