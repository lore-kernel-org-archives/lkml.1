Return-Path: <linux-kernel-owner+w=401wt.eu-S1757564AbZLIUDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564AbZLIUDn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 15:03:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756975AbZLIUDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 15:03:42 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:21903 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbZLIUDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 15:03:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=pOZPAZV5eGsyKm474OxfhfxnAKkrOl3MgSASKKDuytXeb/yN74GAULAsCapZoGUosr
         hU9KZGhDbsUCZ3jIcqAHtdkyDeZlCV7mpaGvjWPqEMRjeERPl7jKSzVR6x6B6k6AcwsI
         r9YNwK1rTRcbq4hWHDmHUcmhEy9aAuz5oqcSs=
Message-ID: <4B20029F.90405@gmail.com>
Date: Wed, 09 Dec 2009 21:03:43 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-13.1 Thunderbird/3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Subject: Re: [PATCH 1/1] X86: use explicit register name for get/put_user
References: <1260091808-8053-1-git-send-email-jslaby@suse.cz> <4B1C01F4.8020304@zytor.com> <4B1CF701.3070805@gmail.com> <4B1D4B0C.9030108@zytor.com>
In-Reply-To: <4B1D4B0C.9030108@zytor.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2009 07:35 PM, H. Peter Anvin wrote:
> On 12/07/2009 04:37 AM, Jiri Slaby wrote:
>> In the document they write only about the "same location" occupied by in
>> and out, nothing is said about size (and hence I think we cannot
>> mismatch size of operands). And I couldn't find any other
>> restrictions/documentation about inline assembly, hence the patch,
>> because nothing assured me this cannot change in the future.
> 
> There is almost no documentation at all; some of the little
> documentation there is is in comments in the source code.  To a first
> order of approximation, asm() is defined by behavior, not by a written
> spec.  Trying to play language lawyer with the little bit that is
> written down is pointless -- the gcc people have been more than happy to
> break asm() between releases regardless of what is and is not written down.

Ok, thanks for the explanation.

-- 
js
