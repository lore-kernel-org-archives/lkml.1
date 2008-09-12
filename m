Return-Path: <linux-kernel-owner+w=401wt.eu-S1758030AbYILVTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030AbYILVTY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 17:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755294AbYILVTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 17:19:17 -0400
Received: from gw.goop.org ([64.81.55.164]:47230 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952AbYILVTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 17:19:16 -0400
Message-ID: <48CADCD2.3000406@goop.org>
Date: Fri, 12 Sep 2008 14:19:14 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alex Nixon <alex.nixon@citrix.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] x86/paravirt: Remove duplicate	paravirt_pagetable_setup_{start,done}()
References: <1220449000-15264-1-git-send-email-alex.nixon@citrix.com> <20080905154655.GH10292@elte.hu>
In-Reply-To: <20080905154655.GH10292@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Alex Nixon <alex.nixon@citrix.com> wrote:
>
>   
>> They were already called once in arch/x86/kernel/setup.c - we don't need to call them again.
>>
>> Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
>> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
>> Cc: Ingo Molnar <mingo@elte.hu>
>>     
>
> applied to tip/x86/paravirt - thanks.
>   

This fixes a regression in -rc, so it should probably go to Linus.  See
http://bugzilla.kernel.org/show_bug.cgi?id=11485

    J
