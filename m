Return-Path: <linux-kernel-owner+w=401wt.eu-S1756564AbZKDO1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbZKDO1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 09:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756525AbZKDO1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 09:27:18 -0500
Received: from xenbox.codefidence.com ([92.48.73.16]:38751 "EHLO
	xenbox.codefidence.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756431AbZKDO1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 09:27:17 -0500
Message-ID: <4AF18F41.9040500@codefidence.com>
Date: Wed, 04 Nov 2009 16:27:13 +0200
From: Gilad Ben-Yossef <gilad@codefidence.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Valdis.Kletnieks@vt.edu, netdev@vger.kernel.org, ori@comsleep.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] Use defaults when no route options are available
References: <4AF07024.80103@gmail.com>	<1257276085-13681-1-git-send-email-gilad@codefidence.com> <20091104.052816.74593826.davem@davemloft.net>
In-Reply-To: <20091104.052816.74593826.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:

> From: Gilad Ben-Yossef <gilad@codefidence.com>
> Date: Tue,  3 Nov 2009 21:21:25 +0200
>
>   
>> Trying to parse the option of a SYN packet that we have
>> no route entry for should just use global wide defaults
>> for route entry options.
>>
>> Signed-off-by: Gilad Ben-Yossef <gilad@codefidence.com>
>>     
>
> The tester has indicated that this doesn't solve things
> for them.  I suspect there is another dependency on 'dst'
> not being NULL in another path somewhere.
>
> So until this is fully resolved I'm holding off on applying
> this patch.
>
>   
Yes, indeed.

I managed to replicate it here. Looking into it right now.

Thanks,
Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker & CTO
Codefidence Ltd.

Web:   http://codefidence.com
Cell:  +972-52-8260388
Skype: gilad_codefidence
Tel:   +972-8-9316883 ext. 201
Fax:   +972-8-9316884
Email: gilad@codefidence.com

Check out our Open Source technology and training blog - http://tuxology.net

	"The biggest risk you can take it is to take no risk."
		-- Mark Zuckerberg and probably others

