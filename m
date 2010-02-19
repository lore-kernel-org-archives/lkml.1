Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab0BSRRY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:17:24 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:33280 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082Ab0BSRRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:17:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=uXcNUFn8i54bK7DDuUlrQ/ct1uUeDEZ+LfMV1UAq9urmLi8J/oWcxzChPUQzbSntSl
         z/SZuWBvqKm1Pz+V3ZIg/b61WWsd4u4tEN5Xgl0Swru3o2GKFPDrnczGLKEwMIQHwGgR
         wlnrx4ocnESCWEVosh3MpZGGjGdUJOYdZF5bA=
Date: Fri, 19 Feb 2010 18:17:05 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Michael Stefaniuc <mstefani@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>,
       Alexandre Julliard <julliard@winehq.org>,
       "Rafael J . Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: Regression in ptrace (Wine) starting with 2.6.33-rc1, fixes
Message-ID: <20100219171646.GA4921@nowhere>
References: <4B7881AC.5070209@redhat.com> <1266516001-7753-1-git-send-regression-fweisbec@gmail.com> <4B7D94AD.4050504@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4B7D94AD.4050504@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 08:27:41PM +0100, Michael Stefaniuc wrote:
> Thanks Frederic!
>
> On 02/18/2010 06:59 PM, Frederic Weisbecker wrote:
>> I still can't build the wine tree (even with the wine faq)
>> because of the following error:
>>
>> LD_LIBRARY_PATH="../../libs/wine:$LD_LIBRARY_PATH" ../../tools/wrc/wrc --nostdinc -I. -I. -I../../include -I../../include  -D__WINESRC__ -D_KERNEL32_  -folocale_rc.res locale_rc.rc
>> Source: �Q�� a4 51 a4 eb
>> Unicode:  5341 6708
>> Back: �̤� a2 cc a4 eb
>> nls/cht.nls:84:16: Error: String �Q�� does not convert identically to Unicode and back in codepage 950. Try using a Unicode string instead
>> make[1]: *** [locale_rc.res] Erreur 1
> Wow, what Wine version are you trying to build? That was a known
> regression but it was fixed 1-2 days later.
>


Hmm, it's a git clone from the wine repo, probably 5 days old.



>> So I can't test these fixes by myself (although I've tested locally
>> with a home made POKEUSER ->  PEEKUSER match test).
>>
>> Could you please test the following tree? You can pull it on top
>> of Linus tree, or clone it.
>>
>> It's here:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
>> 	perf/urgent
> I have just applied your two patches on top of current git. I have run  
> the specific test (make exception.ok) as well as full winetest.exe run:
> The ptrace regressions impacting Wine are all fixed.



Great!



> Thanks again for the quick resolution.
> bye


And thanks a lot for all your testing.
I'm adding your tested-by and will push the patches.

