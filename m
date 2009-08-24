Return-Path: <linux-kernel-owner+w=401wt.eu-S1753740AbZHXWKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbZHXWKu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 18:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753068AbZHXWKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 18:10:48 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:50264 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883AbZHXWKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 18:10:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=toqkzRj6EABCAu3i779Tvbnkq+WUYVXj8B2hzhFq8mdDuLnj9Vob/QEdk4bBjGnsmm
         MCO1s5+VUiyc8mb107rMbRyfJaNNa1NacJPDgBxoK8JB1GN7BLGVJP30BPBgQDSv5D/1
         nmR9EcfZGXSTKf26gqEHqEP1bHvix/QsyvCFE=
Message-ID: <4A930FE4.6090209@gnu.org>
Date: Tue, 25 Aug 2009 00:10:44 +0200
From: Paolo Bonzini <bonzini@gnu.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Avi Kivity <avi@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
       gleb@redhat.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] eventfd: new EFD_STATE flag
References: <20090820155655.GA8764@redhat.com> <alpine.DEB.2.00.0908200916300.14844@makko.or.mcafeemobile.com> <4A8D8A28.2050004@redhat.com> <20090820175540.GA9232@redhat.com> <4A8D90BB.2030506@redhat.com> <20090820182847.GB9282@redhat.com> <4A913DA9.1020403@redhat.com> <20090823133620.GA12841@redhat.com> <4A9146E3.2090007@redhat.com> <20090823143021.GA27495@redhat.com> <alpine.DEB.2.00.0908241114501.7951@makko.or.mcafeemobile.com> <4A92DC93.6030406@redhat.com> <alpine.DEB.2.00.0908241503150.7951@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.2.00.0908241503150.7951@makko.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> There are userspace libraries that do almost everything, but you hardly
> see things like pthread_(EFD_STATE-like)_create() or similar system
> interfaces based on such abstraction.

It actually seems as close to a condition variable as an eventfd can be.

Paolo
