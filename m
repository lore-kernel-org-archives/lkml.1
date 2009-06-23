Return-Path: <linux-kernel-owner+w=401wt.eu-S1758086AbZFWVrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086AbZFWVrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 17:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755389AbZFWVrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 17:47:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51207 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751175AbZFWVrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 17:47:05 -0400
Date: Tue, 23 Jun 2009 14:46:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, kvm@vger.kernel.org,
       ghaskins@novell.com, rusty@rustcorp.com.au, bcrl@kvack.org
Subject: Re: [patch] eventfd - revised interface and cleanups (2nd rev)
Message-Id: <20090623144638.22ca61ea.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0906231428460.17001@makko.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0906230936280.17001@makko.or.mcafeemobile.com>
	<alpine.DEB.1.10.0906231219450.17001@makko.or.mcafeemobile.com>
	<20090623131848.b876d42e.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0906231400010.17001@makko.or.mcafeemobile.com>
	<20090623142909.42776e75.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0906231428460.17001@makko.or.mcafeemobile.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 14:34:50 -0700 (PDT)
Davide Libenzi <davidel@xmailserver.org> wrote:

> On Tue, 23 Jun 2009, Andrew Morton wrote:
> 
> > > Should functions be describing all the returned error codes, ala man pages?
> > > 
> > 
> > I think so.
> 
> This becomes pretty painful when the function calls other functions, for 
> which just relays the error code.
> Should we be just documenting the error codes introduced by the function 
> code, and say that the function returns errors A, B, C plus all the ones 
> returned by the called functions X, Y, Z?
> If not, it becomes hell in maintaining the comments...

Well.  Don't worry about making rules.  Taste and common sense apply.  "Will
it be useful to readers if I explicitly document the return value".  If
"yes" then document away.  If "no" then don't.


