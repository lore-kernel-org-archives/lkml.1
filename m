Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbXJ3Xh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbXJ3Xh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 19:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbXJ3Xhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 19:37:50 -0400
Received: from ozlabs.org ([203.10.76.45]:55900 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbXJ3Xht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 19:37:49 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: kallsyms __print_symbol prints first weak symbol encountered
Date: Wed, 31 Oct 2007 10:38:04 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org,
       "systemtap@sourceware.org" <systemtap@sourceware.org>
References: <20071030174902.GA6513@Krystal>
In-Reply-To: <20071030174902.GA6513@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710311038.04554.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 October 2007 04:49:02 Mathieu Desnoyers wrote:
> kallsyms returns the first symbol encountered, even though it is weak,
> when it should in fact return sys_ni_syscall.

Yes, it's an arbitrary choice, but preferring non-weak symbols would 
definitely be a win.

Thanks!
Rusty.
