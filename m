Return-Path: <linux-kernel-owner+w=401wt.eu-S1754608AbZCRTgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbZCRTgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 15:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750737AbZCRTgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 15:36:38 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:13018 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbZCRTgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 15:36:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=PsGgeUUopkD/Qyqrk7lOpeNb7J9/+La5yPUxiwO8fffIGMiaPpQuzyQhuQ/NWFgBil
         2hbLS/TvzcG08HuVc20YtCub0z1H69hGI3r4cyTOG0+285u+vDCRJalaQV2iL9Sy4MBx
         kaxVBeQeT07ZhSPe2ITjK+kH/C49zeVekUeoo=
Message-ID: <49C14D33.9000009@vflare.org>
Date: Thu, 19 Mar 2009 01:06:19 +0530
From: Nitin Gupta <nitingupta910@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3]: xvmalloc memory allocator
References: <49BF8ABC.6040805@vflare.org> <49BF8B8B.40408@vflare.org>	 <alpine.DEB.1.10.0903171237180.21582@qirst.com>	 <d760cf2d0903171028o600dc94cn7a5238520d104455@mail.gmail.com>	 <alpine.DEB.1.10.0903171355410.26058@qirst.com>	 <49C11088.7000205@vflare.org>	 <alpine.DEB.1.10.0903181258110.15570@qirst.com>	 <d760cf2d0903181029r43bf417u502b46e08348f6ae@mail.gmail.com> <84144f020903181221t480caa5dhef0e581a7bef006@mail.gmail.com>
In-Reply-To: <84144f020903181221t480caa5dhef0e581a7bef006@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> Yeah, I can see the point in having a custom allocator for this. But
> quite frankly the xvmalloc code is just too ugly to live with. You
> might want to make it look like kernel code as per CodingStyle and
> change the name to something less generic.
> 

In beginning I also thought CamelCase coding would be a problem.
But quite frankly, this is best I could do to beautify xvmalloc code.

I will change it to kernel_style. Maybe that helps.

Thanks,
Nitin

