Return-Path: <linux-kernel-owner+w=401wt.eu-S1030329AbXAaRWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030329AbXAaRWI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 12:22:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030340AbXAaRWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 12:22:07 -0500
Received: from ns1.suse.de ([195.135.220.2]:54671 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030331AbXAaRWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 12:22:06 -0500
From: Andi Kleen <ak@suse.de>
To: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: Re: [PATCH] x86_64: Fix preprocessor condition
Date: Wed, 31 Jan 2007 18:16:02 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, torvalds@osdl.org
References: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org> <11702634681921-git-send-email-jsipek@cs.sunysb.edu>
In-Reply-To: <11702634681921-git-send-email-jsipek@cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701311816.02372.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> -#if defined(__KERNEL__) && __x86_64__
> +#if defined(__KERNEL__) && defined(__x86_64__)

Undefined symbols are replaced with 0, so the old line was already ok.
	
-Andi
