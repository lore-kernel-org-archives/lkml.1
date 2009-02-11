Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbZBKOq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbZBKOq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 09:46:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754240AbZBKOqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 09:46:49 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:27074 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807AbZBKOqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 09:46:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CXVDj+GG4SQ095qqp+4n1nhHZOUMl9wMnKWaqHLLMd/f/HI6iZb8aUbDn00s22s132
         wm/WOXKuJHKhh7lc4Gbl8QiakiA1h8zqzUVoqfO8DAt/DtJUGgiZlKWoodgnBp5C0sYR
         h3l7zR02WFNZVVQbCLpnhv13EIf7MOlIsSc7U=
MIME-Version: 1.0
In-Reply-To: <4992E3CF.4040100@kernel.org>
References: <1234277507-4987-1-git-send-email-brgerst@gmail.com>
	 <1234277507-4987-2-git-send-email-brgerst@gmail.com>
	 <499281B5.2070502@kernel.org>
	 <73c1f2160902110634m779e16f6he9620a7c6c021d12@mail.gmail.com>
	 <4992E3CF.4040100@kernel.org>
Date: Wed, 11 Feb 2009 09:46:46 -0500
Message-ID: <73c1f2160902110646o5c76785anb93efab5821eba23@mail.gmail.com>
Subject: Re: [PATCH 1/3] x86: Use pt_regs pointer in do_device_not_available()
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 11, 2009 at 9:42 AM, Tejun Heo <tj@kernel.org> wrote:
> Brian Gerst wrote:
>> I don't quite follow what you are trying to say here.  Are you saying
>> use the same calling convention for the exception handlers (anything
>> called from error_code) and system calls?
>
> Yeap.

Doesn't make sense to me, two very fundamentally different things.  I
supposed you could eliminate the error_code parameter, but that's alot
of work to remove just one instruction.

--
Brian Gerst
