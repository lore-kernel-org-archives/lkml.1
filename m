Return-Path: <linux-kernel-owner+w=401wt.eu-S1756670AbYFSDOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbYFSDOb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 23:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbYFSDOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 23:14:23 -0400
Received: from elcamino.pasemi.com ([67.155.108.98]:39055 "EHLO
	elcamino.pasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbYFSDOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 23:14:23 -0400
X-Spam-Flag: NO
Cc: Nathan Lynch <ntl@pobox.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>
Message-Id: <02FCB4F0-AA68-479F-9BF3-15FC54714C2D@lixom.net>
From: Olof Johansson <olof@lixom.net>
To: Olof Johansson <olof@lixom.net>
In-Reply-To: <BD25BA47-04A5-4FF7-86FD-959BCDB898A0@lixom.net>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v924)
Subject: Re: [RFC/PATCH 3/3] adjust cpu power for secondary threads on POWER6
Date: Wed, 18 Jun 2008 22:03:27 -0500
References: <1213835374-10868-1-git-send-email-ntl@pobox.com> <1213835374-10868-4-git-send-email-ntl@pobox.com> <BD25BA47-04A5-4FF7-86FD-959BCDB898A0@lixom.net>
X-Mailer: Apple Mail (2.924)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 18, 2008, at 9:58 PM, Olof Johansson wrote:

> Why not just NULL out the cpu_power function pointers on platforms  
> that don't have the feature bit instead? (or the other way around:  
> NULL by default, and set only on platforms that have imbalanced  
> threads.

Nevermind; bogus optimization. I just noticed that it's only used when  
setting up the sched domains, and isn't adding path length later on. :)


-Olof
