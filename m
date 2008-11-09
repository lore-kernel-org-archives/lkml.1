Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbYKIKdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbYKIKdY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 05:33:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbYKIKdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 05:33:15 -0500
Received: from rv-out-0506.google.com ([209.85.198.237]:16707 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbYKIKdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 05:33:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=HkWai/0QMPNYOwviavBvsGDhEyEdiv+GTk8aNRyMSarho4q5rjiWKa4IEiYyKjQzQG
         mvjgks1qCp5826Bv2iJhghH/RK02mfqano1kdrZU16WNkwpfkoRpLJrC/SPGxC5u3F5p
         5zPEHazmZjoPL16UKmPf2jgiGLqI4UcL0FKuM=
Message-ID: <5ff4a1e50811090233l18a8cb6cnd89956539a1fd510@mail.gmail.com>
Date: Sun, 9 Nov 2008 10:33:13 +0000
From: "Matt Fleming" <mjf@gentoo.org>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] HPET: Read from HPET_Tn_CMP() not HPET_T0_CMP
Cc: tglx@linutronix.de, mingo@elte.hu, venkatesh.pallipadi@intel.com
In-Reply-To: <1225641860-6120-3-git-send-email-mjf@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225641860-6120-1-git-send-email-mjf@gentoo.org>
	 <1225641860-6120-2-git-send-email-mjf@gentoo.org>
	 <1225641860-6120-3-git-send-email-mjf@gentoo.org>
X-Google-Sender-Auth: cb53e37e23211c6a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/2 Matt Fleming <mjf@gentoo.org>:
> In hpet_next_event() we check that the value we just wrote to
> HPET_Tn_CMP(timer) has reached the chip. Currently, we're checking that
> the value we wrote to HPET_Tn_CMP(timer) is in HPET_T0_CMP, which, if
> timer is anything other than timer 0, is likely to fail.
>

Any comments on this set of patches?
