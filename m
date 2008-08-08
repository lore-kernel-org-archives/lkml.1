Return-Path: <linux-kernel-owner+w=401wt.eu-S1756386AbYHHST4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386AbYHHST4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 14:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbYHHSTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 14:19:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:64980 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbYHHSTr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 14:19:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 0/4] kernel-based checkpoint restart
Date: Fri, 8 Aug 2008 20:18:45 +0200
User-Agent: KMail/1.9.9
Cc: containers@lists.linux-foundation.org, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>
References: <20080807224033.FFB3A2C1@kernel> <200808081125.12706.arnd@arndb.de> <1218218784.19082.10.camel@nimitz>
In-Reply-To: <1218218784.19082.10.camel@nimitz>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808082018.45715.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18VAJcUisosvgyB3hKlghHFT215YKX12HRP5eh
 zA61DToDMyVnq8u+pAlpH1xX7f4bKFzNwbw76m/JUPtbe/GRbd
 Rft6FwWwceTqkw+SC3b4Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 August 2008, Dave Hansen wrote:
> I don't think it is the common case.  Probably now when we're screwing
> around with it, but not in the future.  Do you think it is worth adding
> the pid=0 handling?

If it's the exception, probably not. Otherwise it would be a nice shortcut
to avoid having to do two system calls every time you write code using it.
Then again, there are probably not many programs calling it anyway, if it
get encapsulated in some user space tool.

	Arnd <><
