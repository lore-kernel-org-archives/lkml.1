Return-Path: <linux-kernel-owner+w=401wt.eu-S1757703AbZFWVl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703AbZFWVl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 17:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757739AbZFWVk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 17:40:58 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:40332 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755998AbZFWVkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 17:40:55 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 23 Jun 2009 14:34:50 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, avi@redhat.com,
       kvm@vger.kernel.org, ghaskins@novell.com,
       Rusty Russell <rusty@rustcorp.com.au>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [patch] eventfd - revised interface and cleanups (2nd rev)
In-Reply-To: <20090623142909.42776e75.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0906231428460.17001@makko.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0906230936280.17001@makko.or.mcafeemobile.com> <alpine.DEB.1.10.0906231219450.17001@makko.or.mcafeemobile.com> <20090623131848.b876d42e.akpm@linux-foundation.org> <alpine.DEB.1.10.0906231400010.17001@makko.or.mcafeemobile.com>
 <20090623142909.42776e75.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009, Andrew Morton wrote:

> > Should functions be describing all the returned error codes, ala man pages?
> > 
> 
> I think so.

This becomes pretty painful when the function calls other functions, for 
which just relays the error code.
Should we be just documenting the error codes introduced by the function 
code, and say that the function returns errors A, B, C plus all the ones 
returned by the called functions X, Y, Z?
If not, it becomes hell in maintaining the comments...



- Davide


