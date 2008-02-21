Return-Path: <linux-kernel-owner+w=401wt.eu-S1758348AbYBUJC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758348AbYBUJC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 04:02:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbYBUJCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 04:02:42 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:55340
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbYBUJCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 04:02:40 -0500
Message-ID: <47BD3E2E.3080009@qumranet.com>
Date: Thu, 21 Feb 2008 11:02:38 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: kvm-devel <kvm-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] [PATCH] kvm: sparse fixes for kvm/x86.c
References: <1203445550.10464.10.camel@brick>
In-Reply-To: <1203445550.10464.10.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> In two case statements, use the ever popular 'i' instead of index:
> arch/x86/kvm/x86.c:1063:7: warning: symbol 'index' shadows an earlier one
> arch/x86/kvm/x86.c:1000:9: originally declared here
> arch/x86/kvm/x86.c:1079:7: warning: symbol 'index' shadows an earlier one
> arch/x86/kvm/x86.c:1000:9: originally declared here
>
> Missing semicolon.
> arch/x86/kvm/x86.c:493:3: warning: returning void-valued expression
>
> Make it static.
> arch/x86/kvm/x86.c:1945:24: warning: symbol 'emulate_ops' was not declared. Should it be static?
>
> Drop the return statements.
> arch/x86/kvm/x86.c:2878:2: warning: returning void-valued expression
> arch/x86/kvm/x86.c:2944:2: warning: returning void-valued expression
>   

Applied all three patches, thanks.

-- 
error compiling committee.c: too many arguments to function

