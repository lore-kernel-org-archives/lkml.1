Return-Path: <linux-kernel-owner+w=401wt.eu-S1755858AbXJITDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbXJITDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 15:03:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbXJITC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 15:02:59 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:29117 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbXJITC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 15:02:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=WOFWO411UiU+gL8IV40f43OALYwQjWnzTWgpYSoX7e+jNNkLnx2u21qHrmGWBtc1LCTyNMHshZAFYeOjtGdTliGHOlJB6Ibbx9wzCFE9y9DJ9+KhgRtvIO3xX0QT8CWokoRXiGm6xW3NCHKcW05pcKepRFO/dedycJX7vhJXoPI=
Message-ID: <84144f020710091202u6b617b0ep81759d6a2696614b@mail.gmail.com>
Date: Tue, 9 Oct 2007 22:02:57 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [PATCH -mm] slub: fix cpu hotplug offline/online path
Cc: "Akinobu Mita" <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0710091149221.32730@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071009161328.GA6470@APFDCB5C>
	 <Pine.LNX.4.64.0710091144020.32162@schroedinger.engr.sgi.com>
	 <84144f020710091148s6267a69aud18348af77f941b0@mail.gmail.com>
	 <Pine.LNX.4.64.0710091149221.32730@schroedinger.engr.sgi.com>
X-Google-Sender-Auth: 42a330f38c2d9811
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On 10/9/07, Christoph Lameter <clameter@sgi.com> wrote:
> Our system come by default with the possibility of 1k cpus. However, a
> small system may only have 8 cpus.

Maybe I am reading the code wrong, but I don't why that matters as
it's all statically allocated anyway (the per-cpu kmem_cache_cpu
array). In any case, I certainly don't object to your proposal, just
can't figure out why it matters.

                                   Pekka
