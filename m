Return-Path: <linux-kernel-owner+w=401wt.eu-S1755044AbZG2XZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbZG2XZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 19:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754254AbZG2XZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 19:25:30 -0400
Received: from smtp-out.google.com ([216.239.45.13]:10893 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311AbZG2XZ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 19:25:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=m/Vk+5Ihonx1PHdb7IM3B5PNFnt5SIWDnOAtDu1YAp7Edv1cJppuVcnpWzvh7bAvr
	Skmz8Z2cEY721KLY95pfg==
MIME-Version: 1.0
In-Reply-To: <20090729161341.269b90e3.akpm@linux-foundation.org>
References: <alpine.DEB.2.00.0907282125260.554@chino.kir.corp.google.com>
	 <20090729161341.269b90e3.akpm@linux-foundation.org>
Date: Wed, 29 Jul 2009 16:25:22 -0700
Message-ID: <6599ad830907291625k697f17d3h87d054d796c59407@mail.gmail.com>
Subject: Re: [patch -mm v2] mm: introduce oom_adj_child
From: Paul Menage <menage@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, riel@redhat.com,
       kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 4:13 PM, Andrew Morton<akpm@linux-foundation.org> wrote:
>
> Do we really need to do all that string hacking?  All it does is reads
> a plain old integer from userspace.

It would be nice to have the equivalent of the cgroupfs read_u64 and
write_u64 methods, where you just supply a function that
accepts/returns the appropriate value, and all the buffer munging is
done in the generic code.

Paul
