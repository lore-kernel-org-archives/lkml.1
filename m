Return-Path: <linux-kernel-owner+w=401wt.eu-S1753653AbXDLVVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbXDLVVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 17:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753894AbXDLVVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 17:21:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:49345 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653AbXDLVVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 17:21:34 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH UPDATE] deflate stack usage in lib/inflate.c
Date: Thu, 12 Apr 2007 23:21:23 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Tim Yamin <plasmaroo@gentoo.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <461DED14.1070603@goop.org> <461E9BAD.8050202@goop.org>
In-Reply-To: <461E9BAD.8050202@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704122321.23318.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> (This was under Xen, but there's no reason it couldn't happen on bare
>   hardware.)

Hmm, does Xen perhaps not use interrupt stacks? Normally 2.7k should be still
green as long as there are not too many functions above/below it.

-Andi
