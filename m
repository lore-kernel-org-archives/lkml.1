Return-Path: <linux-kernel-owner+w=401wt.eu-S1755676AbYERTqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676AbYERTqF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 15:46:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbYERTpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 15:45:54 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:43005 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbYERTpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 15:45:53 -0400
Date: Sun, 18 May 2008 21:45:51 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Alok Kataria <akataria@vmware.com>
cc: penguin-kernel@i-love.sakura.ne.jp, devzero@web.de,
       linux-kernel@vger.kernel.org, Dan Hecht <dhecht@vmware.com>
Subject: Re: Kernel hangs in SMP + VMware environment.
In-Reply-To: <1210789834.8798.20.camel@promb-2n-dhcp368.eng.vmware.com>
Message-ID: <alpine.LNX.1.10.0805182145010.15590@fbirervta.pbzchgretzou.qr>
References: <1210789834.8798.20.camel@promb-2n-dhcp368.eng.vmware.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2008-05-14 20:30, Alok Kataria wrote:
>On Wed, May 14, 2008 at 4:00 AM, Tetsuo Handa
><penguin-kernel@i-love.sakura.ne.jp> wrote:
>> Hello.
>>
>> Roland wrote:
>>> maybe related to http://bugzilla.kernel.org/show_bug.cgi?id=9834  ?
>> Thank you for URL.
>> My bug seems to be timer related.

I too noticed it; clocksource=pit is my current workaround.

>>> you say "recent" , so this does happen from 2.6.21 to 2.6.26rc2 ?
>
>> I don't know exact version, but I don't experience this problem
>> in earlier kernels (e.g. Fedora Core 5 which uses kernel 2.6.20).

It does not happen for 2.6.23, and IIRC it did not with 2.6.24
either; 2.6.25-rcish is the first to show this behavior.
Oh well, time to bisect.
