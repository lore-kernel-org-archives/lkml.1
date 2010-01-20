Return-Path: <linux-kernel-owner+w=401wt.eu-S1752795Ab0ATWAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab0ATWAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 17:00:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428Ab0ATWAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 17:00:01 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:39377 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab0ATWAA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 17:00:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=kYmFWO6OZ6k4N0qfMovRvMwfSYLHL3GTlSUkqYzePKdWuw/CMslH8r4xFIdcHvYQfg
         OwRzMR+WioMwFcHMTTaKWSXLOeIJxUX/F9l6MWUVFAq92AiLqK05p2ST9WBAz2gESozt
         fu/8Bjx3Q7gBMswCBy+5n94iXp8xtNKcehKl4=
MIME-Version: 1.0
In-Reply-To: <1264021607.4283.1118.camel@laptop>
References: <20100120171231.922420383@linutronix.de>
	 <1264021607.4283.1118.camel@laptop>
Date: Wed, 20 Jan 2010 22:59:58 +0100
X-Google-Sender-Auth: 55851c93a1690f71
Message-ID: <520f0cf11001201359h660a3b5auabfd2efc162398d5@mail.gmail.com>
Subject: Re: [patch 0/3] sched: Make Priority Inheritance POSIX compliant
From: John Kacur <jkacur@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Carsten Emde <cbe@osadl.org>,
       Mathias Weber <mathias.weber.mw1@roche.com>,
       Clark Williams <williams@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 10:06 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-01-20 at 20:58 +0000, Thomas Gleixner wrote:
>> The current PI implementation violates POSIX scheduling semantics when
>> a thread is deboosted. The following patch series adresses this.
>>
>> Thanks and Kudos go to Mathias Weber and Carsten Emde for analysis,
>> test cases and initial workaround patches.

Oh, that sounds good - would you like to share the test cases for our
rt-test suite?

>
> These look fine to me,
>
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
