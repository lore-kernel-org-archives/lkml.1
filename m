Return-Path: <linux-kernel-owner+w=401wt.eu-S964802AbXBNWFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964802AbXBNWFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 17:05:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964800AbXBNWF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 17:05:29 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964797AbXBNWF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 17:05:27 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070214213200.GA4852@us.ibm.com> 
References: <20070214213200.GA4852@us.ibm.com>  <Pine.LNX.4.64.0702141121030.20368@woody.linux-foundation.org> <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com> <7291.1171482057@redhat.com> 
To: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       herbert.xu@redhat.com, linux-kernel@vger.kernel.org, davej@redhat.com,
       arjan@infradead.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/6] MODSIGN: Kernel module signing 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Wed, 14 Feb 2007 21:59:37 +0000
Message-ID: <9513.1171490377@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Halcrow <mhalcrow@us.ibm.com> wrote:

> Right now, eCryptfs just delegates its modular exponentiation
> operations to a userspace daemon. If RSA ever finds its way into the
> kernel, I might tweak eCryptfs to use that instead for some of the
> public key operations.

Am I right in thinking that RSA uses many of the same MPI lib bits as DSA?

David
