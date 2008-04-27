Return-Path: <linux-kernel-owner+w=401wt.eu-S1763949AbYD0UCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763949AbYD0UCS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 16:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757585AbYD0UCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 16:02:06 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:42875 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755581AbYD0UCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 16:02:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KPC2KGg8WFgTmG7/nHVejkCrdE8t/6X49f8JFW+nxwI94+4BFYDN+fAeOOrn113nZ96dJBAuL5NNRSjY9NGdKHWGcTMQXAgzR+I7TaJGY1DvQENGmzIG+Ed/tKCeUKi5Bog5Qa6kmZMUmgJLdiFLNmrFqJL3j0QEYeuSqxcvJn4=
Message-ID: <9a8748490804271301j5d7c0147x995c5353f9926598@mail.gmail.com>
Date: Sun, 27 Apr 2008 22:01:45 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] PCI Express ASPM support should default to 'No'
Cc: "Shaohua Li" <shaohua.li@intel.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@redhat.com>
In-Reply-To: <87abjjzo84.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LNX.1.00.0804230024210.14359@dragon.funnycrock.com>
	 <200804221712.45972.jbarnes@virtuousgeek.org>
	 <1208912721.31625.3.camel@sli10-desk.sh.intel.com>
	 <87abjjzo84.fsf@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/4/24 Andi Kleen <andi@firstfloor.org>:
>
> Shaohua Li <shaohua.li@intel.com> writes:
>
>  > On Tue, 2008-04-22 at 17:12 -0700, Jesse Barnes wrote:
>  >> On Tuesday, April 22, 2008 3:28 pm Jesper Juhl wrote:
>  >> > Running 'make oldconfig' I just noticed that PCIEASPM defaults to
>  >> > 'y' in Kconfig even though the feature is both experimental and the
>  >> > help text recommends that if you are unsure you say 'n'.
>  >> > It seems to me that this really should default to 'n', not 'y' at the
>  >> > moment.
>  >> > The following patch makes that change. Please consider applying.
>  >>
>  >> Seem reasonable, Shaohua?  Please cc linux-pci on PCI patches
>  >> though...
>  > Ok, I'm fine with the patch. Though by default, the policy is to use
>  > BIOS setting, that is if BIOS disables ASPM, we don't enable it too.
>
>  Once the feature is considered stable it would be nice to make it default y
>  again. I think any power saving should be on by default (unless serious
>  issues are known), not off.
>
I agree, but as long as it's marked EXPERIMENTAL and there's even a
warning in the help text telling users to select 'n' if they are
unsure I think it makes sense to make 'n' the default.
Once it's been tested some more, is no longer experimental, then we
can change it back to 'y' easily.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please http://www.expita.com/nomime.html
