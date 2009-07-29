Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbZG2H23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbZG2H23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 03:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbZG2H22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 03:28:28 -0400
Received: from smtprelay09.ispgateway.de ([80.67.31.43]:34161 "EHLO
	smtprelay09.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbZG2H22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 03:28:28 -0400
References: <1247672919-13089-1-git-send-email-petkovbb@gmail.com> <20090723082904.GE3997@dtor-d630.eng.vmware.com> <cone.1248339143.133822.15136.1000@arca> <9ea470500907230221m1664be8ft2aaf63d2550de6f8@mail.gmail.com> <9ea470500907230553h3ae169c0nc6abaeedb08bef1e@mail.gmail.com> <20090727162940.DA90C526EC9@mailhub.coreip.homeip.net> <20090727183733.GB3044@liondog.tnic> <cone.1248765902.464745.15136.1000@arca> <9ea470500907280208v1d8140b5v9d7d7f09df8f060f@mail.gmail.com> <cone.1248787508.386883.15136.1000@arca> <9ea470500907280659m5a65ac2et67651247bf6925c7@mail.gmail.com>
Message-ID: <cone.1248852351.306728.15136.1000@arca>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, lenb@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acerhdf: convert to dev_pm_ops
Date: Wed, 29 Jul 2009 09:25:51 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

Borislav Petkov writes:

> On Tue, Jul 28, 2009 at 3:25 PM, Peter Feuerer<peter@piie.net> wrote:
> 
> [..]
> 
>>> That's not a reason for keeping code in the kernel and raising bloat
>>> levels unnecessarily. If the driver doesn't need to do anything on
>>> resume, then no function is needed.
>>
>> I don't think the verbose message is useless. If an user has a problem
>> with suspend / hibernate I can just ask him to load the module with
>> verbose=1 and dmesg tells whether the module is waking up or not.
> 
> Since the driver doesn't do anything upon resume, it _is_ _going_ to
> resume just fine. If not, then the problem is located somewhere else,
> i.e. you can safely assume that you are resuming ok. Also, it's not like
> this is the only verbose printk you have in the driver to not be able to
> follow what's going on...

Ok, I think you are right. So we will remove the resume functionality and 
keep just the suspend + freeze calls?

Btw, should I resend the 0.5.13 → 0.5.16 patch splitted up, so that Len can 
apply them?

kind regards,
--peter
