Return-Path: <linux-kernel-owner+w=401wt.eu-S1751831AbXCQVtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831AbXCQVtc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 17:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbXCQVtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 17:49:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:65129 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbXCQVtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 17:49:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [patch 2/13] signal/timer/event fds v6 - signalfd core ...
Date: Sat, 17 Mar 2007 22:50:07 +0100
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
References: <send-serie.davidel@xmailserver.org.9367.1174004536.2> <200703172235.09227.arnd@arndb.de>
In-Reply-To: <200703172235.09227.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703172250.08128.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+uc8TYq5hJ1xYWgPhx3tpfcSDxkNy0kh+BHqE
 2QghYWLwsZSDYciXRlsp+DnNgiwBq74wvKZpcjB94EolxSErHj
 RIBVCc26L/zmRlT4FIY7A==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 March 2007 22:35:08 Arnd Bergmann wrote:
> Also, what's the reasoning behind defining a new structure
> instead of just returning siginfo_t? Sure siginfo_t is ugly
> but it is a well-defined structure and users already deal
> with the problems it causes.

Ok, found the answer myself, fops->read() must not do the
conversion to compat_siginfo_t on a 64 bit kernel, that would
just be too ugly for words.

	Arnd <><
