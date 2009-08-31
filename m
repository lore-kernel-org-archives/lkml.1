Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbZHaSEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbZHaSEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 14:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbZHaSET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 14:04:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49666 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbZHaSET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 14:04:19 -0400
Message-ID: <4A9C1085.50204@zytor.com>
Date: Mon, 31 Aug 2009 11:03:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Borislav Petkov <petkovbb@googlemail.com>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, kjwinchester@gmail.com,
       tglx@linutronix.de, borislav.petkov@amd.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH 3/3] x86, AMD: Disable wrongly set X86_FEATURE_LAHF_LM
 CPUID bit
References: <1251633031-2244-1-git-send-email-petkovbb@gmail.com> <1251633031-2244-3-git-send-email-petkovbb@gmail.com> <4A9AD17A.6060507@zytor.com> <20090830193039.GB22234@liondog.tnic> <4A9ADAC3.3020004@zytor.com> <20090830202926.GC22234@liondog.tnic> <4A9AE5B1.80305@zytor.com> <20090831081426.GA2876@liondog.tnic>
In-Reply-To: <20090831081426.GA2876@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2009 01:14 AM, Borislav Petkov wrote:
> On Sun, Aug 30, 2009 at 01:48:49PM -0700, H. Peter Anvin wrote:
>> The 2x32 bit interface is the legacy interface.  It turned out to be a
>> bad idea, but it's hard to clean up all the users.
> 
> By the way, do we want to switch all rd/wrmsr users to the rd/wrmsrl et
> al interfaces? I could do that gradually - there are only about 400+
> callsites :)
> 

Probably, but I don't consider it a high-priority project.  To me it's
more of a "clean it up as you go" kind of thing.

	-hpa

