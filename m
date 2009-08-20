Return-Path: <linux-kernel-owner+w=401wt.eu-S1754950AbZHTQot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950AbZHTQot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 12:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754940AbZHTQos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 12:44:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51298 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754938AbZHTQos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 12:44:48 -0400
Date: Thu, 20 Aug 2009 09:44:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Howells <dhowells@redhat.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Use the cut_here() function in AFS, CacheFiles,
 FS-Cache and RxRPC
In-Reply-To: <6149.1250784391@redhat.com>
Message-ID: <alpine.LFD.2.01.0908200943180.3158@localhost.localdomain>
References: <alpine.LFD.2.01.0908200816090.3158@localhost.localdomain> <20090820104956.29972.92662.stgit@warthog.procyon.org.uk> <20090820105001.29972.33221.stgit@warthog.procyon.org.uk> <6149.1250784391@redhat.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 20 Aug 2009, David Howells wrote:
>
> What about situations where I want to print quite a lot of information, say
> several lines' worth?

Quite frankly, you shouldn't do that. If your code is so fragile that you 
need a lot of asserts that have small novellas associated with them, just 
don't send that code to me. 

It really is that simple.

		Linus
