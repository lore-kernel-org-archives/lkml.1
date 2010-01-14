Return-Path: <linux-kernel-owner+w=401wt.eu-S1757441Ab0ANSDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441Ab0ANSDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 13:03:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757372Ab0ANSD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 13:03:29 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:32792 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757045Ab0ANSD3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 13:03:29 -0500
X-Greylist: delayed 56522 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Jan 2010 13:03:28 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CigM9ugws9U//N+i1Lyu2fupWk9atakaNh1R1SLKH8u/YlQohFkXrbjiSx3wm1TQTZ
         wLPv+TqvxHTmKN/TKwBoU4Z3Px4dldqce9Ia6bnAP7Hoii1zqjuDB9zEWdMd18aQtLy0
         TN5C5OkJS0kN7L7Y8bY+kFcUu3QEZPpodQfF0=
MIME-Version: 1.0
In-Reply-To: <20100114092350.GF12241@basil.fritz.box>
References: <bc915a051001131745m6fb70dcbx29b9d35f6fd7106c@mail.gmail.com>
	 <87ljg1fn3u.fsf@basil.nowhere.org>
	 <bc915a051001131821x6cdd3470lf72e8c02a897ea3@mail.gmail.com>
	 <20100114092350.GF12241@basil.fritz.box>
Date: Thu, 14 Jan 2010 10:03:27 -0800
Message-ID: <bc915a051001141003s766689beue73800a1308d957e@mail.gmail.com>
Subject: Re: HW breakpoints perf_events request
From: Joshua Pincus <joshua.pincus@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>, peterz@infradead.org,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jan 14, 2010 at 1:23 AM, Andi Kleen <andi@firstfloor.org> wrote:
>> We would like to avoid using ptrace at all costs.
>> It requires us to have a parent thread running
>> which monitors all the others.  It's not clear that
>> the wait() call by the parent doesn't mask a barrage
>> of signals from various threads and the performance
>
> mask? It'll report them. You expect to have so
> many signals that this would be a problem?

Yes.  We expect to see a zillion of them.

> -Andi
>

Thanks,
JP
