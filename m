Return-Path: <linux-kernel-owner+w=401wt.eu-S1750979AbZFSS3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750979AbZFSS3p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 14:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbZFSS3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 14:29:38 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:48455 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbZFSS3i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 14:29:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=HEg/rF+ZchP8ls6orCiQLkpfOeG//P5Js5c07WgbAmxjHCznLt/l47JKFshrm94oqp
         2lwwVVEjJL2opmp45oosQNXh0dF1RqpZdDrSHCdh3JL/xYqogChLYagfdHcDdO5yLv72
         nSC6i0iTnwvzBn5VBrYYEONc6epcB+/4d9XZQ=
MIME-Version: 1.0
In-Reply-To: <200906192332.43672.rusty@rustcorp.com.au>
References: <200906191508.06537.rusty@rustcorp.com.au> <1245397762-13172-1-git-send-email-vapier@gentoo.org> 
	<200906192332.43672.rusty@rustcorp.com.au>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 19 Jun 2009 14:29:20 -0400
Message-ID: <8bd0f97a0906191129kc1b08cdr3373d972f1e710f0@mail.gmail.com>
Subject: Re: [PATCH] module: use MODULE_SYMBOL_PREFIX with module_layout
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Robin Getz <rgetz@blackfin.uclinux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19, 2009 at 10:02, Rusty Russell wrote:
> On Fri, 19 Jun 2009 05:19:22 pm Mike Frysinger wrote:
>> The check_modstruct_version() needs to look up the symbol "module_layout"
>> in the kernel, but it does so literally and not by a C identifier.  The
>> trouble is that it does not include a symbol prefix for those ports that
>> need it (like the Blackfin and H8300 port).  So make sure we tack on the
>> MODULE_SYMBOL_PREFIX define to the front of it.
>
> Thanks, applied.  I'm surprised this took so long to find.

well, technically i first noticed on 2007-10-24, but the fix that went
in internally sucked and people forgot about it ;)
-mike
