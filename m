Return-Path: <linux-kernel-owner+w=401wt.eu-S1751510AbYJSE2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510AbYJSE2r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 00:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750739AbYJSE2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 00:28:39 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:37582 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbYJSE2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 00:28:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=WvfpVx7v2WsIJMFGuvubHQIUmLJ1oPHLU7+tI265JOqcjhUHDyRUwVsHyhc1kTIZfa
         s05m+oHz5QZGApDZ4ct02An0crPEeHlEgzvQMxvr9XW3k+muEtOdx/M8RubJ8MDP+M5p
         Xqc3i7C2FFyrp6NcjjMeonpK2JMxmbHonAFD8=
Message-ID: <86802c440810182128g392483ddt121157a87301a005@mail.gmail.com>
Date: Sat, 18 Oct 2008 21:28:37 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [git pull] drm patches for 2.6.27-rc1
Cc: "Keith Packard" <keithp@keithp.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Dave Airlie" <airlied@linux.ie>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       dri-devel@lists.sf.net, "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20081018223214.GA5093@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.0.82.0810172227490.14817@skynet.skynet.ie>
	 <200810181237.49784.nickpiggin@yahoo.com.au>
	 <1224357062.4384.72.camel@koto.keithp.com>
	 <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org>
	 <20081018203741.GA23396@elte.hu>
	 <1224366690.4384.89.camel@koto.keithp.com>
	 <20081018223214.GA5093@elte.hu>
X-Google-Sender-Auth: f7a11a15f3a0fb84
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2008 at 3:32 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> (In fact if we installed it into the linear kernel address space, and if
> the aperture is 1GB aligned, we will automatically use gbpages for it.
> Were Intel to support gbpages in the future ;-)
>

we could expand init_memory_mapping to support direct map for them...
with needed prot.
or use set init_memory_mapping() + set_memory_wb() directly.

but that is only for 64bit x86

also someone is talking about to have 6 pcie display adapters on 64bit
system. and every card will have 4g ram.

32bit could use fix map for 1G or 2G mapping.

YH
