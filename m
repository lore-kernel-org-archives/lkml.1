Return-Path: <linux-kernel-owner+w=401wt.eu-S1753300AbYKAWrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbYKAWrz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 18:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbYKAWrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 18:47:47 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:11877 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbYKAWrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 18:47:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=VqwQ2mMwhWGkGPsDxzrc6CrC5GW6axxUsaoZBO4obI0GFwG7cXf1IS6snDeUnMu/Zc
         SLWnRGs1pgRGR4h1lJzX+qHkrcaYVUSL2jweC55TSaGdEXNF4t29iGX7HvD3aNL//vk1
         v7D94l/GR2OMx60paLidI9Cc+SNPPFxlW1WeY=
Message-ID: <86802c440811011547k11ab1640h4a0c51fdc6c9fb39@mail.gmail.com>
Date: Sat, 1 Nov 2008 15:47:46 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Jonathan Corbet" <corbet@lwn.net>
Subject: Re: 2.6.28-rc2 hates my e1000e
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Robert Hancock" <hancockr@shaw.ca>,
       e1000-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>,
       "Steven Rostedt" <rostedt@goodmis.org>
In-Reply-To: <20081101164509.5e53762c@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.P5jmIAOhSJ192sfWD+qlec07fe8@ifi.uio.no>
	 <alpine.LFD.2.00.0810310839380.21084@nehalem.linux-foundation.org>
	 <20081031100040.1f0cf34f@bike.lwn.net>
	 <alpine.LFD.2.00.0810310916050.21084@nehalem.linux-foundation.org>
	 <20081031105105.092ebad3@bike.lwn.net>
	 <alpine.LFD.2.00.0810310953550.21084@nehalem.linux-foundation.org>
	 <20081101090154.3d014f57@bike.lwn.net>
	 <alpine.LFD.2.00.0811010958230.6226@nehalem.linux-foundation.org>
	 <86802c440811011250g662b8c4di31f2e391c910954e@mail.gmail.com>
	 <20081101164509.5e53762c@bike.lwn.net>
X-Google-Sender-Auth: f7a3252975b78ffe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 1, 2008 at 3:45 PM, Jonathan Corbet <corbet@lwn.net> wrote:
> On Sat, 1 Nov 2008 12:50:20 -0700
> "Yinghai Lu" <yinghai@kernel.org> wrote:
>
>> Jonathan, can you try patch i sent?
>>
>> http://lkml.org/lkml/2008/10/31/274
>> [PATCH] x86: remove PCI bar range from e820 reserved entries
>
> OK, I tried it.  No joy.
..
>
> Looks to me like Linus's patch is the way to go, at least for now...
>

yes Linus's is right.

YH
