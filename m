Return-Path: <linux-kernel-owner+w=401wt.eu-S1762555AbYDVIxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762555AbYDVIxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 04:53:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759610AbYDVIwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 04:52:55 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:7820 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757176AbYDVIwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 04:52:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=DlhqnEewf+3Ek/qDrVB2YewWRFD/+CW2+g8qwBHOrIS1poSOm0Fzo96md9qAydF+2ev9PeO2+RRI/Xf8qmulGdRX2uaFugT/99AIEuuLo5rqt+KXfVEFybbTE8if1k0HarfY9MiFsRB9dS8pxT4LUVO2qNdgCyJnppsMKjqvepU=
Message-ID: <480DA670.4060707@gmail.com>
Date: Tue, 22 Apr 2008 10:48:48 +0200
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org, Ingo Molnar <mingo@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/11] x86: convert to generic helpers for IPI function
 calls
References: <1208851058-8500-1-git-send-email-jens.axboe@oracle.com> <1208851058-8500-3-git-send-email-jens.axboe@oracle.com> <20080422084738.GB2388@elte.hu>
In-Reply-To: <20080422084738.GB2388@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar pisze:
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
>> This converts x86 and x86-64 to use the new helpers for 
>> smp_call_function() and friends, and adds support for 
>> smp_call_function_single().
> 
> nice stuff. The x86 and generic bits:
> 
>  Acked-by: Ingo Molnar <mingo@elte.hu>
> 
> this has been brewing for months, what is the testing/confidence status 

A'propos testing: Jens did you placed all patches (latest versions) somewhere on
net, so I can grab it and test?

> of it? Could we still merge it into v2.6.26? (i think we should)

-Jacek
