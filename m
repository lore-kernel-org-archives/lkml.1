Return-Path: <linux-kernel-owner+w=401wt.eu-S1753525AbZFGXJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbZFGXJt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 19:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbZFGXJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 19:09:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53641 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750955AbZFGXJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 19:09:40 -0400
Date: Sun, 7 Jun 2009 16:09:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mimi Zohar <zohar@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Serge Hallyn <serue@us.ibm.com>, James Morris <jmorris@namei.org>,
       Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] integrity: fix IMA inode leak
In-Reply-To: <1244354901.3963.23.camel@dyn9002018117.watson.ibm.com>
Message-ID: <alpine.LFD.2.01.0906071608040.6847@localhost.localdomain>
References: <Pine.LNX.4.64.0906062109580.8365@sister.anvils>  <alpine.LFD.2.01.0906061416170.6847@localhost.localdomain> <1244354901.3963.23.camel@dyn9002018117.watson.ibm.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 7 Jun 2009, Mimi Zohar wrote:
> 
> Mandatory Access Control(MAC) modules (i.e. SELinux, smack, etc) and
> integrity (i.e IMA) are two different aspects of security.  The LSM
> hooks, which includes security_inode_free(), are used to implement MAC,
> not integrity.

So?

It's under security/integrity. And it's a level of detail that fs/inode.c 
really doesn't care about.

The VFS layer cares NOT AT ALL about your "different aspects of security", 
nor should it. The fact that security people think SELinux and IMA are 
different is irrelavant - fs/inode.c just doesn't care. Why should it?

		Linus
