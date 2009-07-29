Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbZG2N3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbZG2N3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755488AbZG2N3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:29:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:42029 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755373AbZG2N3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:29:16 -0400
Message-ID: <4A704EAC.6070201@suse.de>
Date: Wed, 29 Jul 2009 15:29:16 +0200
From: Alexander Graf <agraf@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/12] Nested SVM cleanups
References: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com> <4A70492E.2080705@redhat.com> <20090729130944.GE18313@amd.com> <4A704F5B.9000800@redhat.com>
In-Reply-To: <4A704F5B.9000800@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> On 07/29/2009 04:09 PM, Joerg Roedel wrote:
>>> I seem to recall nested smp used to be broken.  Am I mistaken, or do
>>> these patches fix rather than clean up?
>>>      
>>
>> Nested SMP was broken in one of the early version of the nested SVM
>> code. In the current upstream version it works quite well.
>>    
>
> In that case, the next interesting target is nested npt.  This may
> actually make nsvm perform well.  Any plans?

IMHO the next interesting target is nested Hyper-V :-).

But yes, nested NPT is really interesting too and more on the lines of
what Joerg's precious time should be spent on ;-). I'll try and see if I
can get nested Hyper-V running until LPC.

Alex

