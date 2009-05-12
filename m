Return-Path: <linux-kernel-owner+w=401wt.eu-S1759951AbZELLnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759951AbZELLnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 07:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbZELLnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 07:43:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:58945 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbZELLne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 07:43:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2] x86: fix ktermios-termio conversion
Date: Tue, 12 May 2009 13:42:18 +0200
User-Agent: KMail/1.9.9
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-arch@vger.kernel.org
References: <20090511222702.352192505@arndb.de> <200905121104.31275.arnd@arndb.de> <20090512091010.GD18004@elte.hu>
In-Reply-To: <20090512091010.GD18004@elte.hu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905121342.19093.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+Sz9/51bM1AkDh9NgHAd2jvaTG8CQi3kbqc8B
 76jq1e7Rs1RJ0XA2BQmNqCWzuCCeSWZdUNJY8Q4WLZpZK3Wwzu
 csKJVTQcwOYUg/1/0Z29w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 May 2009, Ingo Molnar wrote:
> hm, on x86 you could use get_user_try / get_user_ex() / 
> get_user_catch() approach to linearize the dependencies and reduce 
> register pressure.

Yes, but that would not help my intention of making the file more
generic. The x86 code was copied into a number of architectures, and
at least arm, m32r, parisc, sh and xtensa have big-endian configurations
where the implementation is wrong.

I only realized that while writing this email though and I guess I
need to fix those as well now ;-) 

	Arnd <><
