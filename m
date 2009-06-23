Return-Path: <linux-kernel-owner+w=401wt.eu-S1752288AbZFWRK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288AbZFWRK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 13:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750979AbZFWRKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 13:10:14 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:48409 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbZFWRKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 13:10:13 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 23 Jun 2009 10:04:00 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Avi Kivity <avi@redhat.com>
cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org,
       Gregory Haskins <ghaskins@novell.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [patch] eventfd - revised interface and cleanups
In-Reply-To: <4A410AD1.8080304@redhat.com>
Message-ID: <alpine.DEB.1.10.0906231000540.17001@makko.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0906230936280.17001@makko.or.mcafeemobile.com> <4A410AD1.8080304@redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009, Avi Kivity wrote:

> On 06/23/2009 07:47 PM, Davide Libenzi wrote:
> > The following patch changes the eventfd interface to de-couple the eventfd
> > memory context, from the file pointer instance.
> > Without such change, there is no clean way to racely free handle the
> > POLLHUP event sent when the last instance of the file* goes away.
> > Also, now the internal eventfd APIs are using the eventfd context instead
> > of the file*.
> > Another cleanup this patch does, is making AIO select EVENTFD, instead of
> > adding a bunch of empty function stubs inside eventfd.h.
> > 
> > Andrew, this better go via Avi and the KVM tree, since they have patches
> > that will be based on the new interface.
> >    
> 
> The kvm patches will only be ready for 2.6.32.  Can this go in 2.6.31 now, and
> we'll meet in 10 weeks?

Either ways works for me.
Meanwhile, I'll repost with the revised documentation format.


- Davide


