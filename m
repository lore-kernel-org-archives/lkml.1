Return-Path: <linux-kernel-owner+w=401wt.eu-S1757290AbZC0Ps0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290AbZC0Ps0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 11:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756030AbZC0PsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 11:48:17 -0400
Received: from vena.lwn.net ([206.168.112.25]:39320 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755776AbZC0PsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 11:48:16 -0400
Date: Fri, 27 Mar 2009 09:48:12 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Dan Carpenter <error27@gmail.com>
Cc: linux-kernel@vger.kernel.org, eteo@redhat.com
Subject: Re: [patch] char/raw.c locking on error
Message-ID: <20090327094812.32d0d5e7@bike.lwn.net>
In-Reply-To: <Pine.LNX.4.64.0903262243150.4167@usbsys.site>
References: <Pine.LNX.4.64.0903262243150.4167@usbsys.site>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Mar 2009 13:28:48 +0300 (EAT)
Dan Carpenter <error27@gmail.com> wrote:

> This bug was found by smatch (http://repo.or.cz/w/smatch.git/).  Compile 
> tested only, sorry.

But clearly correct.  This is probably my fault, duh.  I've grabbed the
fix into the bkl-removal tree in case it doesn't get in via some faster
path.

(I bet raw doesn't need BKL at all; I'll see if I can't find some time
to have a look later on).

Thanks,

jon
