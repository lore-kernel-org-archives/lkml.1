Return-Path: <linux-kernel-owner+w=401wt.eu-S1754440AbZKEAVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbZKEAVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 19:21:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbZKEAVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 19:21:05 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:49467 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbZKEAVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 19:21:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lyGh5L21UMoMfB+dGr6qwiLcWcch28MxQll5Z8T8zo/sDiXQ54gTDl11OAahsPGsuP
         RcEL/cs+BU4apXelMAmClUsZv0qf9ucakDSMy9LjC2p+ol16cTYuofIVezuQapHRLB81
         LPMuhH+Kynp54i1IyHej1tzwL8J0SLiRxSUAY=
Message-ID: <4AF21E0C.90506@gmail.com>
Date: Thu, 05 Nov 2009 00:36:28 +0000
From: Dave Korn <dave.korn.cygwin@googlemail.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Justin Mattock <justinmattock@gmail.com>
CC: Dave Korn <dave.korn.cygwin@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gcc@gcc.gnu.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Rientjes <rientjes@cs.washington.edu>
Subject: Re: cc1plus invoked oom-killer: gfp_mask=0x280da, order=0, oom_adj=0
References: <dd18b0c30911021329g3c99a783n6b0a293240c3312c@mail.gmail.com>	 <20091103222432.4a94bd8f.akpm@linux-foundation.org>	 <4AF17DED.7080808@gmail.com> <4AF198E1.9010303@gmail.com>	 <4AF1A198.1090709@gmail.com>	 <dd18b0c30911040839ice58f81v7c8aa10e79f5d1b8@mail.gmail.com>	 <4AF1DA8D.9070009@gmail.com> <4AF1E66D.6060705@gmail.com> <dd18b0c30911041322y2cfd58f8m168550bbe3e8234b@mail.gmail.com>
In-Reply-To: <dd18b0c30911041322y2cfd58f8m168550bbe3e8234b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Mattock wrote:
> here's what I did:
>  valgrind --tool=memcheck --leak-check=full -v make -f client.mk build

> ==4072== LEAK SUMMARY:

> I'll try out gdb, and more of valgrind.

  Yep, that doesn't tell us a lot in its default modes.  I'm not a valgrind
expert but it looks from the docs like you want to try the Massif tool: it
looks really thorough.

http://valgrind.org/docs/manual/ms-manual.html

    cheers,
      DaveK


