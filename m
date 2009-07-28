Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbZG1N77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbZG1N77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 09:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751320AbZG1N77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 09:59:59 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:49044 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbZG1N76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 09:59:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wHlkT7vqoHfwwJfjwCSu73OvCvPwg7rp0a71htcsy60CiRTjYHvS+X2+P0+OWOyBOd
         EEe9f0fzPw5OFNBTdVY9o4JWbDez08YzS8iWUWfnpno+ARBNSz3CgSUytI12bxleu2Du
         jvI+tg/PJhZlqL1ydrtrLZJwKXN5E134GqXUY=
MIME-Version: 1.0
In-Reply-To: <cone.1248787508.386883.15136.1000@arca>
References: <1247672919-13089-1-git-send-email-petkovbb@gmail.com>
	 <20090723082904.GE3997@dtor-d630.eng.vmware.com>
	 <cone.1248339143.133822.15136.1000@arca>
	 <9ea470500907230221m1664be8ft2aaf63d2550de6f8@mail.gmail.com>
	 <9ea470500907230553h3ae169c0nc6abaeedb08bef1e@mail.gmail.com>
	 <20090727162940.DA90C526EC9@mailhub.coreip.homeip.net>
	 <20090727183733.GB3044@liondog.tnic>
	 <cone.1248765902.464745.15136.1000@arca>
	 <9ea470500907280208v1d8140b5v9d7d7f09df8f060f@mail.gmail.com>
	 <cone.1248787508.386883.15136.1000@arca>
Date: Tue, 28 Jul 2009 15:59:58 +0200
Message-ID: <9ea470500907280659m5a65ac2et67651247bf6925c7@mail.gmail.com>
Subject: Re: [PATCH] acerhdf: convert to dev_pm_ops
From: Borislav Petkov <petkovbb@googlemail.com>
To: Peter Feuerer <peter@piie.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, lenb@kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 3:25 PM, Peter Feuerer<peter@piie.net> wrote:

[..]

>> That's not a reason for keeping code in the kernel and raising bloat
>> levels unnecessarily. If the driver doesn't need to do anything on
>> resume, then no function is needed.
>
> I don't think the verbose message is useless. If an user has a problem
> with suspend / hibernate I can just ask him to load the module with
> verbose=1 and dmesg tells whether the module is waking up or not.

Since the driver doesn't do anything upon resume, it _is_ _going_ to
resume just fine. If not, then the problem is located somewhere else,
i.e. you can safely assume that you are resuming ok. Also, it's not like
this is the only verbose printk you have in the driver to not be able to
follow what's going on...

-- 
Regards/Gruss,
Boris
