Return-Path: <linux-kernel-owner+w=401wt.eu-S1753773AbYHWLDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773AbYHWLDg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 07:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbYHWLD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 07:03:28 -0400
Received: from senator.holtmann.net ([87.106.208.187]:43043 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbYHWLD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 07:03:28 -0400
Subject: Re: [PATCH] ath9k: remove useless if-before-kfree; correct
	misleading indentation
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Jim Meyering <meyering@redhat.com>
Cc: linux-kernel@vger.kernel.org, Sujith.Manoharan@atheros.com,
       linville@tuxdriver.com
In-Reply-To: <87myj4rpsa.fsf_-_@rho.meyering.net>
References: <87zln4rzce.fsf@rho.meyering.net>
	 <1219485762.7591.476.camel@violet.holtmann.net>
	 <87myj4rpsa.fsf_-_@rho.meyering.net>
Content-Type: text/plain
Date: Sat, 23 Aug 2008 13:03:43 +0200
Message-Id: <1219489423.7591.480.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jim,

> >> Alternatively, you could remove the nowadays-useless
> >> "if-before-kfree" test and leave the sometimes-redundant
> >> assignment as-is: unconditional.
> >
> > actually the later one is preferred. Just remove the NULL check.
> 
> I prefer it, too, but the indentation suggested that
> adding braces would match the author's intent.
> 
> In case anyone is interested, I have been maintaining a patch
> that removes *all* useless if-before-kfree tests.  I have not
> posted it because such changes have a reputation for provoking
> flames on this list, but now you've provoked me ;-)
> 
>     http://meyering.net/code/remove-useless-if-before-kfree.patch
>      74 files changed, 127 insertions(+), 250 deletions(-)

I am all for this patch.

Even the Glibc free() function will do an "if-before-free" :)

Regards

Marcel


