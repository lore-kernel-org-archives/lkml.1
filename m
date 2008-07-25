Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbYGYCN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbYGYCN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 22:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbYGYCNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 22:13:19 -0400
Received: from ozlabs.org ([203.10.76.45]:48150 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818AbYGYCNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 22:13:18 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 0/4] typesafe callbacks
Date: Fri, 25 Jul 2008 12:13:17 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807251213.17773.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's possible to portably make callbacks typesafe, as well as taking the 
existing void * arg.  This makes the callers more readable and more typesafe.

Done in a way that doesn't break non-gcc: they just don't get a warning.

Been in linux-next for about two full cycles now, and I really want to start 
using this in my own code.

Thanks,
Rusty.
