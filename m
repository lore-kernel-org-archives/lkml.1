Return-Path: <linux-kernel-owner+w=401wt.eu-S1755468AbZKCJJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468AbZKCJJq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 04:09:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755580AbZKCJJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 04:09:45 -0500
Received: from www84.your-server.de ([213.133.104.84]:35582 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488AbZKCJJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 04:09:44 -0500
Subject: Re: [PATCH] fix X86_64 procfs provide stack information for threads
From: Stefani Seibold <stefani@seibold.net>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20091103090608.GA3898@x200>
References: <1257158829.5199.26.camel@wall-e>  <20091103090608.GA3898@x200>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 03 Nov 2009 10:09:45 +0100
Message-ID: <1257239385.4889.17.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 03.11.2009, 12:06 +0300 schrieb Alexey Dobriyan:
> On Mon, Nov 02, 2009 at 11:47:09AM +0100, Stefani Seibold wrote:
> > The 32 bit loader compat_do_execve did not store stack start (this was
> > figured out by alexey).
> 
> yeah, but let's not mix it since these are two different issues
> and KSTK_ESP should go through Ingo.

Ingo has contacted me... He has some complains about the #ifdef, so i
remove it. I will put you on the list.


