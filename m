Return-Path: <linux-kernel-owner+w=401wt.eu-S1754964Ab0AEQFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964Ab0AEQFe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 11:05:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754880Ab0AEQFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 11:05:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763Ab0AEQFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 11:05:32 -0500
Message-ID: <4B43631A.2030101@redhat.com>
Date: Tue, 05 Jan 2010 18:04:42 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Jun Koi <junkoi2004@gmail.com>
CC: Gleb Natapov <gleb@redhat.com>, kvm@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, hpa@zytor.com, riel@redhat.com,
       cl@linux-foundation.org
Subject: Re: [PATCH v3 00/12] KVM: Add host swap event notifications for PV
 	guest
References: <1262700774-1808-1-git-send-email-gleb@redhat.com> <fdaac4d51001050705s3f46dd0fi948a3b3ea803fa51@mail.gmail.com>
In-Reply-To: <fdaac4d51001050705s3f46dd0fi948a3b3ea803fa51@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2010 05:05 PM, Jun Koi wrote:
> Is it true that to make this work, we will need a (PV) kernel driver
> for each guest OS (Windows, Linux, ...)?
>
>    

It's partially usable even without guest modifications; while servicing 
a host page fault we can still deliver interrupts to the guest (which 
might cause a context switch and thus further progress to be made).

-- 
error compiling committee.c: too many arguments to function

