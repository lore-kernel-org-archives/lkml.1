Return-Path: <linux-kernel-owner+w=401wt.eu-S1757475AbZGGPjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475AbZGGPjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 11:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755642AbZGGPjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 11:39:06 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:48131 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627AbZGGPjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 11:39:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=oCit2Xcpv8TDwgoKgC9iv1Uer3+M7ect1UuGUpFx+U9yjvK0XjRtCrP9Inag1C1WBx
         9PO32MVKf8W2gl6hDza/d22w0VGB5fXWbIgorrk3YhmukqYsTDYwUbfb3wiVjQdf/Zwu
         70dUVpOKYLfx7KDKzghxnAQVi7snUwtxaJAX4=
MIME-Version: 1.0
In-Reply-To: <a5d9929e0907070838q7ed3306du3bb7880e47d7207b@mail.gmail.com>
References: <a5d9929e0907070825j1dda6584t93196e2730dedc5c@mail.gmail.com> 
	<1246980836.9777.5.camel@twins> <a5d9929e0907070838q7ed3306du3bb7880e47d7207b@mail.gmail.com>
From: Joao Correia <joaomiguelcorreia@gmail.com>
Date: Tue, 7 Jul 2009 16:38:41 +0100
Message-ID: <a5d9929e0907070838m7cf45976p2ab1885c0c5ea756@mail.gmail.com>
Subject: Fwd: [PATCH 1/3] Increase lockdep limits: MAX_STACK_TRACE_ENTRIES
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(clumsy fingers part 2, forwarding to the list)


---------- Forwarded message ----------
From: Joao Correia <joaomiguelcorreia@gmail.com>
Date: Tue, Jul 7, 2009 at 4:38 PM
Subject: Re: [PATCH 1/3] Increase lockdep limits: MAX_STACK_TRACE_ENTRIES
To: Peter Zijlstra <a.p.zijlstra@chello.nl>


Yes. Anything 2.6.31 forward triggers this immediatly during init
process, at random places.

Joao Correia

On Tue, Jul 7, 2009 at 4:33 PM, Peter Zijlstra<a.p.zijlstra@chello.nl> wrote:
> On Tue, 2009-07-07 at 16:25 +0100, Joao Correia wrote:
>> (Applies to current Linus tree, as of 2.6.31-rc2)
>>
>> As it stands now, the limit is too low and is being hit by false
>> positives. Increasing its value will allow for more room to work with.
>>
>> This was suggested by Ingo Molnar
>> (http://article.gmane.org/gmane.linux.kernel/852005) but never
>> submitted as a patch, to the best of my knowledge.
>
> Right, we found a bug in the dma-debug code that generated tons of
> classes where only 1 was needed, which in turn generated tons of chains
> and stack entries.
>
> But that got merged, but you're seeing more of this?
>
>
