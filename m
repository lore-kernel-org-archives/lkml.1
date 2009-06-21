Return-Path: <linux-kernel-owner+w=401wt.eu-S1752394AbZFUMra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbZFUMra (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 08:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751043AbZFUMrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 08:47:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37246 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbZFUMrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 08:47:20 -0400
Message-ID: <4A3E2BB7.2070008@redhat.com>
Date: Sun, 21 Jun 2009 15:46:47 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       KVM list <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip][KVM] x86: kvm/x86_emulate.c toggle_interruptibility()
 should be static
References: <1245324205.7189.6.camel@localhost.localdomain>
In-Reply-To: <1245324205.7189.6.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2009 02:23 PM, Jaswinder Singh Rajput wrote:
> toggle_interruptibility() is used only by same file, it should be static.
>
> Fixed following sparse warning :
>
>    arch/x86/kvm/x86_emulate.c:1364:6: warning: symbol 'toggle_interruptibility' was not declared. Should it be static?
>    

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

