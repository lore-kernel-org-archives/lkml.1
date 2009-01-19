Return-Path: <linux-kernel-owner+w=401wt.eu-S1761469AbZASNN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761469AbZASNN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 08:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760175AbZASNMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 08:12:46 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48564 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760107AbZASNMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 08:12:45 -0500
Message-ID: <49747C44.1030901@redhat.com>
Date: Mon, 19 Jan 2009 15:12:36 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: Avoid using CONFIG_ in userspace visible headers
References: <1232370050-7434-1-git-send-email-avi@redhat.com> <20090119130927.GC6876@elte.hu>
In-Reply-To: <20090119130927.GC6876@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Avi Kivity <avi@redhat.com> wrote:
>
>   
>> Kconfig symbols are not available in userspace, and are not stripped by
>> headers-install.  Avoid their use by adding #defines in <asm/kvm.h> to
>> suit each architecture.
>>
>>     
> looks good - you will push this via the KVM tree, right?
>   

Yes.  Thanks for the review.

-- 
error compiling committee.c: too many arguments to function

