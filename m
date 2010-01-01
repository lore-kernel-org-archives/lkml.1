Return-Path: <linux-kernel-owner+w=401wt.eu-S1751891Ab0AAOn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891Ab0AAOn3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 09:43:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764Ab0AAOn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 09:43:28 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57912 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751667Ab0AAOn2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 09:43:28 -0500
Date: Fri, 1 Jan 2010 14:46:29 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: daw-news@taverner.cs.berkeley.edu (David Wagner)
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH v3] Unprivileged: Disable raising of privileges
Message-ID: <20100101144629.54fe6cb6@lxorguk.ukuu.org.uk>
In-Reply-To: <hhioif$j9t$3@taverner.cs.berkeley.edu>
References: <m1iqbpwjtp.fsf@fess.ebiederm.org>
	<m2bphfti1u.fsf@ssh.synack.fr>
	<e7d8f83e0912310608j2c52acabxbd57d24e2b3073ca@mail.gmail.com>
	<20091231170641.6dd46c6e@lxorguk.ukuu.org.uk>
	<hhioif$j9t$3@taverner.cs.berkeley.edu>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Dec 2009 17:55:27 +0000 (UTC)
daw@cs.berkeley.edu (David Wagner) wrote:

> Alan Cox  wrote:
> >Removing specific features from a specific piece of code
> >generally isn't a security feature -
> 
> You lost me there.  The ability of a specific piece of code to voluntarily
> relinquish privileges can be a big benefit to security. 

Can be - but its historically been an endless source of bugs and flaws
because the code being run after you take the rights away is being run in
an environment it didn't expect and wasn't tested in.

>From inanities like setting the file size limit to 0 and running passwd
blanking the password file (SGI Irix) to closing file handle 0 or setting
cpu quotas to make a forked daemon process die unexpectedly the list is
endless.

Alan
