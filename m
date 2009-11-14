Return-Path: <linux-kernel-owner+w=401wt.eu-S1751313AbZKNSof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751313AbZKNSof (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 13:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbZKNSof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 13:44:35 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:33365 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbZKNSoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 13:44:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=jhGvM//RT/1OyHj0aVJsTrgdnhN/nDfcTCz+iNMXIrxcFKSDsGMVGHhWmpZWxz2Vd3
         uTLuATN1QuiycqEtDrpXCzVdQxRvJx+wNvfCqcXgIj2UozVuQCat4KtFKdiTcki/lD4/
         ndZ6ApliIbLtEnyul0cbkrTnyua5gibhVVaTA=
Message-ID: <4AFEFA94.8060207@gmail.com>
Date: Sat, 14 Nov 2009 19:44:36 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091112 SUSE/3.0.0-1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, "Brown, Len" <len.brown@intel.com>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Yong Wang <yong.y.wang@linux.intel.com>
Subject: Re: resume crashes in intel_init_thermal [was: mmotm 2009-11-13-19-59
 uploaded]
References: <200911140403.nAE43CN1016851@imap1.linux-foundation.org>	<4AFEB060.80007@gmail.com> <20091114081549.1477fabc.akpm@linux-foundation.org>
In-Reply-To: <20091114081549.1477fabc.akpm@linux-foundation.org>
X-Enigmail-Version: 0.97b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2009 05:15 PM, Andrew Morton wrote:
> Revert
> 
> : commit ce6b5d768c79b9d5dd6345c033bae781d5ca9b8e
> : Author:     Yong Wang <yong.y.wang@linux.intel.com>
> : AuthorDate: Wed Nov 11 15:51:25 2009 +0800
> : Commit:     Ingo Molnar <mingo@elte.hu>
> : CommitDate: Wed Nov 11 12:33:32 2009 +0100
> : 
> :     x86: Mark the thermal init functions __init
> 
> because intel_init_thermal() is called from mce_intel_feature_init() at
> resume time, and we'd like its text to still be in memory when that
> happens.

Works for me. Thanks.

-- 
js
Faculty of Informatics, Masaryk University
Suse Labs, Novell
