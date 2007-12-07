Return-Path: <linux-kernel-owner+w=401wt.eu-S1752746AbXLGOpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbXLGOpA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 09:45:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750735AbXLGOow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 09:44:52 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:62046 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbXLGOov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 09:44:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=sDD8pvlDzYc/SGATTJMDGvHPtRP9LNM5jTgJLtkReK/pZJA+I6KKPhiprx3mbAVbi93AZoeZN66icK7b0st/WZH8Lmo4VDMt5DmLU4lkO+5UKg2RXTfT8uqO0mRxSie4yboeso8l2zabt1LB1Z6NqS79aGiR5YNmEbagtHSQPr0=
Message-ID: <a71bd89a0712070644t57a1fd17rf18819fef83b6a78@mail.gmail.com>
Date: Fri, 7 Dec 2007 06:44:50 -0800
From: "Dan Kegel" <dank@kegel.com>
To: linux-kernel@vger.kernel.org
Subject: re: 2.6.23.8: OOM killer kills wrong jobs
Cc: "=?ISO-8859-1?Q?Martin_MOKREJ=C5?=" <mmokrejs@ribosome.natur.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 087825962b665bd4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marting Mokreja wrote:
> first of all, sorry for not being up to date with how the OOM killer
> works. I think there used to be a kernel config option to disable
> OOM killer and instead kill the process which actually asks for the
> memory and supposedly caused the memory lack. That is what I would
> like to have on my system. I a have a 1GB RAM laptop

You probably just need to add more swap space on your system,

Any time the OOM killer fires, something's wrong with the
system, and it's more productive to deal with that than to
wish for a more accurate OOM killer; see http://lwn.net/Articles/111408/

When I was working at a company that used embedded Linux,
I eventually figured this out, and patched the kernel to panic on OOM
conditions; that gave users the right incentive to avoid
configuring jobs that caused the system to run out of memory.
- Dan
