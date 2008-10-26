Return-Path: <linux-kernel-owner+w=401wt.eu-S1753371AbYJZDMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbYJZDMG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 23:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbYJZDLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 23:11:54 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:58692 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbYJZDLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 23:11:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qz/eWk9xJnVwqlnj3zDhrCcrlyUNdkqxIZQhudCN0IoZ+FETXZFVPs3owu/SOZYuSg
         Y+PRYqxKXHzYEg/TT4cNz2M9S1ssTa4i5l22E38hRUWOsx6ICbmuApnhK3rMi0iWeJQG
         WgzVjGPpO2NoEUk4pPpGvXBxepVohoxLML5cM=
Message-ID: <4903DFF4.5000602@gmail.com>
Date: Sat, 25 Oct 2008 20:11:48 -0700
From: walt <w41ter@gmail.com>
User-Agent: Thunderbird/3.0a2pre (X11; 2008102512)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Arjan van de Ven <arjan@infradead.org>, Hugh Dickins <hugh@veritas.com>
Subject: Re: [PULL] module, param and stop_machine patches
References: <200810221005.59874.rusty@rustcorp.com.au> <alpine.LFD.2.00.0810251416130.3327@nehalem.linux-foundation.org> <200810260924.09479.rusty@rustcorp.com.au> <alpine.LFD.2.00.0810251529240.3327@nehalem.linux-foundation.org> <alpine.LFD.2.00.0810251554030.3327@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0810251554030.3327@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
>
> On Sat, 25 Oct 2008, Linus Torvalds wrote:
>> Is there any reason why the real patch isn't just to make
>> 'stop_machine_init' a 'core_initcall()' instead of 'early_initcall()'?
>
> IOW, something like this (untested)
>
> 		Linus

<patch snipped for brevity>

This patch also fixes the keyboard problem I reported originally.



