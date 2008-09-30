Return-Path: <linux-kernel-owner+w=401wt.eu-S1753654AbYI3Tad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbYI3Tad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 15:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYI3TaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 15:30:25 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:18900 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbYI3TaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 15:30:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=TPPuRD6dJbEEQzET9tpdNrOxpejuCEQIGWYUobo/6e9oKWMabE+KvraiRUodPERbYh
         PuyyhYvftQ/TS6XjOy7cqk9OJfB2Za03FLZ9RN3UiBf7znKt7bH/0gTl95zZNHY2QIPs
         kLIzAwKQIffj1QbgyNASswjtiPMzkPfNuvbGU=
Message-ID: <86802c440809301230s7dd33e69m83dab51f915580b1@mail.gmail.com>
Date: Tue, 30 Sep 2008 12:30:24 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Typo bug [Re: Linux 2.6.27-rc8]
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "=?ISO-8859-1?Q?\"J.A._Magall=F3n\"?=" <jamagallon@ono.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <48E27425.7010705@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.2.00.0809291527460.3389@nehalem.linux-foundation.org>
	 <20080930094346.307ef1e5@werewolf.home>
	 <20080930075553.GB20241@elte.hu> <48E27425.7010705@zytor.com>
X-Google-Sender-Auth: 86f4140a058ec508
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2008 at 11:47 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> Ingo Molnar wrote:
>>>
>>> early_param("enble_mtrr_cleanup", enable_mtrr_cleanup_setup);
>>>             ^^^^^^
>>>
>>> Nice ;)
>>
>> heh. Could you send a patch with a changelog please?
>
> These options are also named inconsistently with all other options.
>
> The standard way to name an boolean option is "foo" versus "nofoo", in this
> case, "mtrrcleanup" vs "nomtrrcleanup".
>
ok, we could change it...

YH
