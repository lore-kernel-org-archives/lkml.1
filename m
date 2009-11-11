Return-Path: <linux-kernel-owner+w=401wt.eu-S1752154AbZKKGXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbZKKGXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 01:23:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbZKKGXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 01:23:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41067 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbZKKGXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 01:23:11 -0500
Message-ID: <4AFA569E.9040206@zytor.com>
Date: Tue, 10 Nov 2009 22:15:58 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
       Avi Kivity <avi@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
References: <4AF9C6AB.8080006@zytor.com> <20091110201602.GA26633@1wt.eu> <20091110205445.GB1407@ucw.cz> <20091110211259.GD26633@1wt.eu> <4AF9D8E2.7050205@zytor.com> <20091110220652.GE26633@1wt.eu> <4AF9E61B.5090407@zytor.com> <20091110222031.GA22911@elte.hu> <20091110224222.GA28648@1wt.eu> <4AF9ED78.3000106@zytor.com> <20091111055220.GA560@1wt.eu>
In-Reply-To: <20091111055220.GA560@1wt.eu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2009 09:52 PM, Willy Tarreau wrote:
> 
>   - last, the probability of having an NX page just after an
>     executable one seems too tight to me to even constitute
>     an attack vector ! BTW, I'm not even certain that all CPUs
>     correctly implement this check !
> 

Do you have *any* *evidence* *whatsoever* for that assertion?!

I personally will consider something that doesn't implement proper
security check to be a potential security hole and will NAK the patch.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

