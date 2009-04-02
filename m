Return-Path: <linux-kernel-owner+w=401wt.eu-S934722AbZDBF55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934722AbZDBF55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 01:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbZDBF5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 01:57:46 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:50237 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbZDBF5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 01:57:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WLL6gepG2/pHI8wVTX1Hb0NxDYgXkCy8BiODjAYBSMiTHK04cUEvfdN5hLZu8E0atW
         T0vqVTxZ5wC8kzJ+PwWoV3LYubFTquiw3xcTBsSbIho326MNywCR042fVtuath//ROGh
         U7vc2CX2M+QGepoHJx3vnjCWT2uEmuFKCqm7A=
MIME-Version: 1.0
In-Reply-To: <20090402054816.GG1117@x200.localdomain>
References: <20090331142533.GR9137@random.random>
	 <20090331150218.GS9137@random.random> <49D23224.9000903@codemonkey.ws>
	 <20090331151845.GT9137@random.random> <49D23CD1.9090208@codemonkey.ws>
	 <20090331162525.GU9137@random.random> <49D24A02.6070000@codemonkey.ws>
	 <20090402012215.GE1117@x200.localdomain>
	 <49D424AF.3090806@codemonkey.ws>
	 <20090402054816.GG1117@x200.localdomain>
Date: Thu, 2 Apr 2009 07:57:42 +0200
Message-ID: <36ca99e90904012257j5f5e6e2co673ff2433d49b7b9@mail.gmail.com>
Subject: Re: [PATCH 4/4 alternative userspace] add ksm kernel shared memory 
	driver
From: Bert Wesarg <bert.wesarg@googlemail.com>
To: Chris Wright <chrisw@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>,
       Andrea Arcangeli <aarcange@redhat.com>, Izik Eidus <ieidus@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
       avi@redhat.com, riel@redhat.com, jeremy@goop.org, mtosatti@redhat.com,
       hugh@veritas.com, corbet@lwn.net, dmonakhov@openvz.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 2, 2009 at 07:48, Chris Wright <chrisw@redhat.com> wrote:
> Ksm api (for users to register region):
>
> Register a memory region as shareable:
>
> madvise(void *addr, size_t len, MADV_SHAREABLE)
>
> Unregister a shareable memory region (not currently implemented):
>
> madvise(void *addr, size_t len, MADV_UNSHAREABLE)
I can't find a definition for MADV_UNSHAREABLE!

Bert
