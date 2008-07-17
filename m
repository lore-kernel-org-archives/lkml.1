Return-Path: <linux-kernel-owner+w=401wt.eu-S1760737AbYGQSkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760737AbYGQSkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 14:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758046AbYGQSj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 14:39:57 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:24641 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757671AbYGQSj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 14:39:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=yD5GaoRie0Km//T7ui0bRz1GSDkSPWwq36bgludFcwgG5ErDMr0v4pk/1JPRZl0EQ5
         +GiMyf9ayO50jKRvebtGEI1zDtSUfb5sgnxKJqWs4+QDChETzx2k0yWaTQ6g34d7k2nf
         ampuMIP6nlRRAnfnGjmWuqBfJiUDTcTaxd+Yc=
Message-ID: <dd18b0c30807171139r77caf0d5vee7c6eff1a6b9157@mail.gmail.com>
Date: Thu, 17 Jul 2008 18:39:55 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: 2.6.26-rc9-git9 doesn't boot on Macintel
Cc: "Jack Howarth" <howarth@bromo.msbb.uc.edu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <86802c440807170942k387c7d73o838584d99457bd30@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440807161029n7e0dac98x1ec260879204b6f0@mail.gmail.com>
	 <86802c440807161749u2f5c1eben618e05c6e254fedd@mail.gmail.com>
	 <20080717023538.GA18329@bromo.msbb.uc.edu>
	 <86802c440807161959s10666027k5297af1d657ff4fa@mail.gmail.com>
	 <20080717034418.GA18951@bromo.msbb.uc.edu>
	 <86802c440807162113g4cea3bd9ic71210330417032b@mail.gmail.com>
	 <20080717061825.GA19582@bromo.msbb.uc.edu>
	 <86802c440807162348m6d05b912x7b3f655d7f9efb93@mail.gmail.com>
	 <20080717162622.GA26835@bromo.msbb.uc.edu>
	 <86802c440807170942k387c7d73o838584d99457bd30@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 4:42 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Thu, Jul 17, 2008 at 9:26 AM, Jack Howarth <howarth@bromo.msbb.uc.edu> wrote:
>> YH,
>>   I am wondering if it might be worthwhile for me to
>> try the various rc releases of 2.6.26 (starting with rc1-git1)
>> to see if I can identify at what point 2.6.26 was broken
>> with regards to booting on my MacBook Pro? In case that
>> would point us towards the checkin of a specific set of
>> patches as the problem.
>
> try 2.6.26-rc1,..rc2
>
> YH
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

O.K. I tried MMCONFIG and it seems
to be giving me a: kernel panic
VFS: cannot open device sda1 or unkown block (0,0)

from what I remember I noticed this as far back as 2.6.22

-- 
Justin P. Mattock
