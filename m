Return-Path: <linux-kernel-owner+w=401wt.eu-S1761377AbZFWRDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761377AbZFWRDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 13:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760658AbZFWRCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 13:02:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34761 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758627AbZFWRCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 13:02:49 -0400
Message-ID: <4A410AD1.8080304@redhat.com>
Date: Tue, 23 Jun 2009 20:03:13 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org,
       Gregory Haskins <ghaskins@novell.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [patch] eventfd - revised interface and cleanups
References: <alpine.DEB.1.10.0906230936280.17001@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0906230936280.17001@makko.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2009 07:47 PM, Davide Libenzi wrote:
> The following patch changes the eventfd interface to de-couple the eventfd
> memory context, from the file pointer instance.
> Without such change, there is no clean way to racely free handle the
> POLLHUP event sent when the last instance of the file* goes away.
> Also, now the internal eventfd APIs are using the eventfd context instead
> of the file*.
> Another cleanup this patch does, is making AIO select EVENTFD, instead of
> adding a bunch of empty function stubs inside eventfd.h.
>
> Andrew, this better go via Avi and the KVM tree, since they have patches
> that will be based on the new interface.
>    

The kvm patches will only be ready for 2.6.32.  Can this go in 2.6.31 
now, and we'll meet in 10 weeks?

-- 
error compiling committee.c: too many arguments to function

