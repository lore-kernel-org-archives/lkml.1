Return-Path: <linux-kernel-owner+w=401wt.eu-S1752491AbYACNGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbYACNGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 08:06:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbYACNG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 08:06:28 -0500
Received: from ns1.suse.de ([195.135.220.2]:56742 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbYACNG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 08:06:27 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] [9/20] x86: Don't use oops_begin in 64bit mce code
Date: Thu, 3 Jan 2008 13:52:42 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <20080103149.088038000@suse.de> <20080103005004.A171C14D40@wotan.suse.de> <20080103103912.GA29194@elte.hu>
In-Reply-To: <20080103103912.GA29194@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801031352.42111.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 January 2008 11:39:12 Ingo Molnar wrote:
> 
> * Andi Kleen <ak@suse.de> wrote:
> 
> > It is not really useful to lock machine checks against oopses. And 
> > machine checks normally don't nest, so they don't need their own 
> > locking. Just call bust_spinlock/console_verbose directly.
> 
> is this in response to any particular incident you've seen?


No, that was a preparatory patch for the "use 64bit machine check code
for 32bit kernels" because 32bit doesn't have oops_begin(), but it is
useful on its own.

-Andi
