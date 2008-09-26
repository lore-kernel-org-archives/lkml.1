Return-Path: <linux-kernel-owner+w=401wt.eu-S1753337AbYIZVMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbYIZVMy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 17:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbYIZVMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 17:12:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:48735 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbYIZVMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 17:12:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=tB5Cyf4FUkkwT1KzoVYypPyPcvmMxz961D9nCwxzMHuaCE9+l23AlFEtJgVtI208JA
         bO/ksotf7NIztfwLEXT9dbKh0YP6Ml1xi6ABDWwFM4iTYMmG469s/XwkMrrYTLh5X6cn
         v3JHANOuWUNMl7ysaUNv1CKvgueUXLyas3Fc4=
Message-ID: <2c0942db0809261412l23424ad0o96a117bce87472dc@mail.gmail.com>
Date: Fri, 26 Sep 2008 14:12:44 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Janos Haar" <djani22@netcenter.hu>
Subject: Re: Whats going on? (somebody can say something?)
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <2e8201c91fba$1befac80$0400a8c0@dcccs>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2e8201c91fba$1befac80$0400a8c0@dcccs>
X-Google-Sender-Auth: 4642c3e7b7bff864
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2008 at 2:27 AM, Janos Haar <djani22@netcenter.hu> wrote:
> Hello list,
>
> Good day for everibody.
>
> I have one problem with my new linux box. (again)
> The hw is tested. (memtest86, 4 days)
>
> The samba freezed and makes 40 load.
>
> All what i am using is in-kernel solution, excepting samba.
>
> libata ->bock -> raid -> cryptoloop -> xfs -> [samba] ->eth

That's pretty much guaranteed to crash if you're using 4k stacks. Are you?

> The log file is here:
> http://download.netcenter.hu/bughunt/20080925/messages

You have oopses in that log, but didn't mention them in your email or
include them within. Please read the reporting bugs document in the
kernel tree to see a better way to get the attention of those who
should be looking at your problem.

Good luck.
