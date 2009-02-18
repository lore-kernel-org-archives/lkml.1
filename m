Return-Path: <linux-kernel-owner+w=401wt.eu-S1752813AbZBRIbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbZBRIbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 03:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbZBRIbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 03:31:08 -0500
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:40232 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751674AbZBRIbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 03:31:07 -0500
Message-ID: <499BD53C.1000007@st.com>
Date: Wed, 18 Feb 2009 10:30:36 +0100
From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-mm@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] slab: fix slab flags for archs use alignment larger 
 64-bit
References: <1234461073-23281-1-git-send-email-peppe.cavallaro@st.com>	 <20090212185640.GA6111@linux-sh.org> <499544AD.3030804@st.com>	 <84144f020902130122y471dd92em4a72de43a0cfc681@mail.gmail.com>	 <49954F9A.5020801@st.com>	 <84144f020902130205x4dc5886l70fe6a695ef050a4@mail.gmail.com>	 <4995565D.5010105@st.com> <49957F98.50708@st.com> <84144f020902130541n6de09d7brb455d0879b62af71@mail.gmail.com>
In-Reply-To: <84144f020902130541n6de09d7brb455d0879b62af71@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,
Pekka Enberg wrote:
> Hi Giuseppe,
>
> On Fri, Feb 13, 2009 at 4:11 PM, Giuseppe CAVALLARO
> <peppe.cavallaro@st.com> wrote:
>   
>> @@ -2262,7 +2266,7 @@ kmem_cache_create (const char *name, size_t size, size_t align,
>>                ralign = align;
>>        }
>>        /* disable debug if necessary */
>> -       if (ralign > __alignof__(unsigned long long))
>> +       if (ralign > ARCH_SLAB_MAX_DEBUG_ALIGN)
>>                flags &= ~(SLAB_RED_ZONE | SLAB_STORE_USER);
>>        /*
>>         * 4) Store it.
>>     
>
> This doesn't address the issues raised by Paul at all.
>
>                                 Pekka
>   
Sorry for my late reply.
You are right.
I'm going to review this but this could take a while.
I'll go back to you as soon as possible.
Regards,
Peppe
//
