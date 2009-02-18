Return-Path: <linux-kernel-owner+w=401wt.eu-S1756504AbZBRTeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbZBRTeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 14:34:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbZBRTd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 14:33:59 -0500
Received: from rv-out-0506.google.com ([209.85.198.238]:21971 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbZBRTd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 14:33:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=uWtRyATTsDoIn0JFYAkcJ6rnoBev3y3ihZ3+SgcmnKRLHuEd0S8rNrjdwyEAwX7Vtf
         z3QR4bzPt6vFLe5F4HBVKlKwLM9AeQHWGprRH5JnaeZ/qg61u3atR4CiPqNYrIlqWwsH
         H6OEBJwznpX6qVGrMI8ri87RaRsdYYpm9/Eyk=
MIME-Version: 1.0
In-Reply-To: <1234927467.4707.15.camel@rzhang-desktop>
References: <1234927467.4707.15.camel@rzhang-desktop>
Date: Wed, 18 Feb 2009 11:33:57 -0800
X-Google-Sender-Auth: f0abf0a98ca8538f
Message-ID: <86802c440902181133x320c80f6ue0dbb38880ffe267@mail.gmail.com>
Subject: Re: i915 regression in 2.6.29-rc5
From: Yinghai Lu <yinghai@kernel.org>
To: ZhangRui <rui.zhang@intel.com>, Ingo Molnar <mingo@elte.hu>
Cc: dri_devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>,
       jbarnes@virtuousgeek.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 7:24 PM, ZhangRui <rui.zhang@intel.com> wrote:
> Hi, all,
>
> I got an i915 failure in 2.6.29-rc5.
>
> problem description: the screen doesn't come back after suspend/resume.
> A workaround is to boot with "nomodesetting".
>
> I got this error message during i915 driver load time,
> [   22.606749] mtrr: type mismatch for e0000000,10000000 old: write-back new: write-combining
> [   22.606752] [drm] MTRR allocation failed
> [   22.606753] .  Graphics performance may suffer.

CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1

may help this one.

YH
