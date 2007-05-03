Return-Path: <linux-kernel-owner+w=401wt.eu-S1767438AbXECVjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767438AbXECVjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 17:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767435AbXECViu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 17:38:50 -0400
Received: from ns.suse.de ([195.135.220.2]:43305 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161485AbXECViq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 17:38:46 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] rename thread_info to stack
Date: Thu, 3 May 2007 23:38:29 +0200
User-Agent: KMail/1.9.6
Cc: Roman Zippel <zippel@linux-m68k.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0705010210010.1479@scrub.home> <20070503141951.d67d0289.akpm@linux-foundation.org>
In-Reply-To: <20070503141951.d67d0289.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705032338.29829.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> It is unpleasing that this code is forced to implicitly assume that the
> thing pointed to by task_struct.stack has type `struct thread_info'.

I can change that to typeof

-Andi
