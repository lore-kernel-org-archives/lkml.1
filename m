Return-Path: <linux-kernel-owner+w=401wt.eu-S1753767AbYFZTKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767AbYFZTKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbYFZTKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:10:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:12775 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbYFZTKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:10:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vjDOCeK+13JzGaM9fHoTew4rtLGyFTc/mn29Nm3lXZbmRJyW9ikTVqmjmcsuhla6+4
         XXJz7/X+yyaKVnHoj4dbp3KWMvlp/QFtY/jHTJxW+BVSZwd+gUrD+MJVJCeedMiNUs3Y
         wIMUwwRi6of4GuRn6Fp4g5pmMkr/WboYots+s=
Message-ID: <86802c440806261210k5ed8e455ke748fe1f8e9b9f00@mail.gmail.com>
Date: Thu, 26 Jun 2008 12:10:13 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Robert Richter" <robert.richter@amd.com>
Subject: Re: [PATCH] x86: rename setup.c to setup_percpu.c
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080626182235.GF1620@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806251037.11391.yhlu.kernel@gmail.com>
	 <20080626170918.GE1620@erda.amd.com>
	 <86802c440806261107t6d2d1d66r4222017d9da29fbc@mail.gmail.com>
	 <20080626182235.GF1620@erda.amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 11:22 AM, Robert Richter <robert.richter@amd.com> wrote:
> On 26.06.08 11:07:15, Yinghai Lu wrote:
>> we want to keep track of setup_32.c
>
> I have seen your patch series afterwards. You are moving back some
> parts of the code. I assume setup_percpu.c will only contain per-cpu
> code in the end?
yes, and some cleanup from Mike triavis.

YH
