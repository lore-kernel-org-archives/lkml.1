Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbZAFS2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbZAFS2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 13:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbZAFS2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 13:28:11 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33777 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751492AbZAFS2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 13:28:10 -0500
Date: Tue, 6 Jan 2009 18:27:59 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Casey Dahlin <cdahlin@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2] waitfd
Message-ID: <20090106182759.0af37351@lxorguk.ukuu.org.uk>
In-Reply-To: <49639EB8.40204@redhat.com>
References: <49639EB8.40204@redhat.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> waitfd provides a file descriptor out of which may be read a series of 
> siginfo_t objects describing child death. A child process is reaped as 
> soon as its information is read. This means child monitoring too can be 
> performed with that same poll call.
> 
> Patch is against v2.6.28

Same comment as last time - the right way to do this is to extend the
existing notify APIs to the /proc file system
