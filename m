Return-Path: <linux-kernel-owner+w=401wt.eu-S1755864AbYLERXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864AbYLERXI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 12:23:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbYLERWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 12:22:54 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:50076 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993AbYLERWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 12:22:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=CC+15ihYPf/HMcRksBa0ZuxfIQQnHGygvL2Oa2zuyNb9l5oQsuQG3bQF4bDQ5qgBPD
         LGZPrutPmak+kUJjsZJFnGGzVEVcZw192Hi5coFN/KgV/FEVrLmAyBQU9FaCwr+M3rq3
         iopza0JjeyxNzebMQeXXoYJiQPQy8yYeEMrrk=
Message-ID: <4939635F.5050102@gmail.com>
Date: Fri, 05 Dec 2008 18:22:39 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Anthony Liguori <aliguori@us.ibm.com>
CC: Mark McLoughlin <markmc@redhat.com>, Michael Tokarev <mjt@tls.msk.ru>,
       Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH] virtio: make PCI devices take a virtio_pci module ref
References: <1228394671.3732.77.camel@blaa> <49385DB7.4060306@gmail.com> <4938EE0B.8020501@msgid.tls.msk.ru>  <493929D2.4070900@gmail.com> <1228488921.3858.25.camel@blaa> <49394C1B.2010001@us.ibm.com>
In-Reply-To: <49394C1B.2010001@us.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori napsal(a):
> Actually, we should be able to delete this virtio_pci_root entirely. 
> The device is a dummy one anyway.

But the bus is still to be fixed...
