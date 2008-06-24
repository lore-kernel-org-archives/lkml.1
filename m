Return-Path: <linux-kernel-owner+w=401wt.eu-S1759744AbYFXLKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759744AbYFXLKu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 07:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbYFXLKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 07:10:42 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:5825 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbYFXLKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 07:10:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZXrAZcHHbxxmTrMNBfpAoi7cizUYQLoieluK6uELcfjdks+ewgicyaWfG0wdDQLHJ6
         yKplBq0fC0r78BBgiZrnJ+Rv3BCJgo3Qn1Qzdt6YKLnEsaDgnpsydt4rFo9osJtKtRIm
         J3Ep+pjwPQK7abm5q9Ctrq71+mF7mbQ6JhK7I=
Message-ID: <86802c440806240410m3565f267wd93090ac1eedee68@mail.gmail.com>
Date: Tue, 24 Jun 2008 04:10:40 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: setup_arch 32bit move kvm_guest_init later
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080624105326.GA12384@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806231951.10898.yhlu.kernel@gmail.com>
	 <200806231953.33437.yhlu.kernel@gmail.com>
	 <200806231954.23694.yhlu.kernel@gmail.com>
	 <200806231955.05921.yhlu.kernel@gmail.com>
	 <20080624105326.GA12384@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2008 at 3:53 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>
> applied all 9 patches to tip/x86/setup-memory. Thanks Yinghai,

please check

[PATCH] x86: introduce init_memory_mapping for 32bit

that will make 32bit flow in setup_arch more clear.

YH
