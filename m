Return-Path: <linux-kernel-owner+w=401wt.eu-S1763599AbXJSKeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763599AbXJSKeQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 06:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509AbXJSKeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 06:34:03 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:38885 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbXJSKeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 06:34:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=eWmBI5PvEDYEL0bLkfxVMfJdzGFPWtHvms1ao8aRLqtRa26vD75OtswPz0yr0GILMcCJ/TVQImI0i0Np4RVV1nqbSAdg6sgAbj0H8VT/9qUuB2MudWL2JTfBCxbnUvO9rIozz6PK478BPAk0goccyTXApggecwI59yyJOWjq8cs=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] ia64: check-segrel.lds vs --build-id
Date: Fri, 19 Oct 2007 11:33:49 +0100
User-Agent: KMail/1.9.1
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Doug Chapman <dchapman@redhat.com>, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org
References: <20071018195453.A34D64D04E2@magilla.localdomain>
In-Reply-To: <20071018195453.A34D64D04E2@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710191133.49970.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 October 2007 20:54, Roland McGrath wrote:
> Some versions of ld with --build-id support will crash when using the flag
> with a linker script that discards notes.  This bites ia64's check-segrel.lds.
> The bug is easy to avoid.

It's fixed in newer ld (not released yet IIRC), but why
are we shooting ourself in the foot by adding --build-id,
and then suffering from --build-id related problems?
--
vda
