Return-Path: <linux-kernel-owner+w=401wt.eu-S1755256AbYIXQjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbYIXQjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 12:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbYIXQjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 12:39:22 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:13440 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbYIXQjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 12:39:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=oyT6/2Lq5KWmCtAh8NatGQtjmGgCx+mvhREFB0tRrTkXYxEFfHG6uIgAHJJpyiP5wD
         4FxlCG7sR04VE/w0jMVaoIUD2ER6q4kwPM1kEuAIig8Qv480zDt9oWuddH4LrFXFw02e
         TDV1OSbwaYOrTOqMjTQlw50F8sn+mPqXK3SVM=
Message-ID: <86802c440809240939h63b14efdm1382ffe4c44c6660@mail.gmail.com>
Date: Wed, 24 Sep 2008 09:39:20 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Yan Li" <elliot.li.tech@gmail.com>
Subject: Re: [PATCH 2/2] Suppress false "mtrr all empty" warning message when running as VMware guest
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, joerg.roedel@amd.com,
       rjmaomao@gmail.com, "Thomas Gleixner" <tglx@linutronix.de>,
       nancydreaming@gmail.com
In-Reply-To: <48da36b3.0e0d6e0a.1c8e.fffff980@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a120cfa37281607d8dc361deda1a35419accd193.1222258080.git.elliot.li.tech@gmail.com>
	 <48da36b3.0e0d6e0a.1c8e.fffff980@mx.google.com>
X-Google-Sender-Auth: c359c39986b72655
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 5:24 AM, Yan Li <elliot.li.tech@gmail.com> wrote:
> Since the mtrr empty was detected very early before we can use DMI or
> PCI to check whether we are running as a VMware guest or not, we now
> only print an info there. Warning will only be issued later when we
> are sure that we are not running as a VMware guest.
>
> mtrr_trim_uncached_memory() is modified to return meaningful codes for
> later warning decision.

we have moved dmi_scan_machine() much early...

so please check with latest tip/master to use
dmi_check_system with that.

BTW:
those warning should be good, because VMware is the root cause.

YH
