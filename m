Return-Path: <linux-kernel-owner+w=401wt.eu-S1753283Ab0AaMGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab0AaMGM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 07:06:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731Ab0AaMGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Jan 2010 07:06:12 -0500
Received: from mail-iw0-f173.google.com ([209.85.223.173]:62319 "EHLO
	mail-iw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab0AaMGL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 07:06:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YpZpyCOF1D2rwZN+4A3Ceq63pgfLQrK14EMWnXhkZ6NTmZuZUGVrhxB5Ntjvc3QgFE
         WzoRh1YJ8VfhwaqbHkfMGQ0S0cC4EE+LrAHzZu3XmFOUAWWrzq/gtuz56HOecKnMQn7i
         gW0huZ4o9YHl/E5OvuSgl1ak83Prh0HDT00Hs=
MIME-Version: 1.0
In-Reply-To: <1264938810-4173-1-git-send-email-akinobu.mita@gmail.com>
References: <1264938810-4173-1-git-send-email-akinobu.mita@gmail.com>
Date: Sun, 31 Jan 2010 14:06:10 +0200
Message-ID: <b6fcc0a1001310406j3924731du4727bd82cb23ea9a@mail.gmail.com>
Subject: Re: [PATCH 1/7] sched: Use for_each_bit
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 31, 2010 at 1:53 PM, Akinobu Mita <akinobu.mita@gmail.com> wrote:
>  #define for_each_cpupri_active(array, idx)                    \
> -  for (idx = find_first_bit(array, CPUPRI_NR_PRIORITIES);     \
> -       idx < CPUPRI_NR_PRIORITIES;                            \
> -       idx = find_next_bit(array, CPUPRI_NR_PRIORITIES, idx+1))
> +       for_each_bit(idx, array, CPUPRI_NR_PRIORITIES)

It should be called for_each_set_bit().
