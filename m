Return-Path: <linux-kernel-owner+w=401wt.eu-S1758364AbZFRRvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758364AbZFRRvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 13:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753017AbZFRRvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 13:51:35 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:45589 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993AbZFRRve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 13:51:34 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 18 Jun 2009 10:45:25 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Gregory Haskins <ghaskins@novell.com>
cc: kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, mst@redhat.com, avi@redhat.com,
       paulmck@linux.vnet.ibm.com, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [KVM PATCH 3/4] eventfd: add generalized notifier interface
In-Reply-To: <20090618174426.24119.69689.stgit@dev.haskins.net>
Message-ID: <alpine.DEB.1.10.0906181044160.32646@makko.or.mcafeemobile.com>
References: <20090618173534.24119.95115.stgit@dev.haskins.net> <20090618174426.24119.69689.stgit@dev.haskins.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jun 2009, Gregory Haskins wrote:

> We currently open-code notification registration via the f_ops->poll()
> method of the eventfd.  Lets abstract this into a notification API
> extension of eventfd, while still using the wait-queue as the underlying
> mechanism.  This will allow us to manage the notification mechanism
> internal to eventfd without requiring the clients to change.  This also
> gives us the opportunity to implement race-free release() callbacks,
> which we do later in the series.

Another attempt to push KVM stuff into eventfd. NACK.


- Davide


