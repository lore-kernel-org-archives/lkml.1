Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbYL1XYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbYL1XYH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 18:24:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbYL1XXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 18:23:55 -0500
Received: from rv-out-0506.google.com ([209.85.198.227]:48154 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbYL1XXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 18:23:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=gsxqol+rW3wkD+gcVPKoU2eEbE4WgkE5K5NppksfqwMXX0hYUz6ofeuLOgiyYCseqa
         GTP+q3IayUQgKLHHiY6ZIfexKU1NtoFytO1S18pFzrPYuUeTHlS72S0zUrKyWoBoIzj7
         f69uDY5bfxPRrv4uweeAA+XMsu3wLBgfAiGT0=
Message-ID: <86802c440812281523q6fafc095t7e44fb5cc625e57c@mail.gmail.com>
Date: Sun, 28 Dec 2008 15:23:53 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [git pull] sparseirq / irq updates for v2.6.29
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "KOSAKI Motohiro" <kosaki.motohiro@gmail.com>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>
In-Reply-To: <alpine.LFD.2.00.0812281510370.3082@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081225160741.GA14486@elte.hu> <20081227133240.GA8716@elte.hu>
	 <2f11576a0812270927taef068fobbad997dc5e5aacf@mail.gmail.com>
	 <20081227173839.GA9793@elte.hu>
	 <alpine.LFD.2.00.0812281510370.3082@localhost.localdomain>
X-Google-Sender-Auth: 9915de9dc5d5c409
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 28, 2008 at 3:11 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Sat, 27 Dec 2008, Ingo Molnar wrote:
>>
>> well, it's a regression that is being worked on: certain buggy GCC
>> versions (unclear yet what scope but quite rare it appears) optimize out
>> __weak function calls incorrectly.
>
> We've hit that kind of bug before, haven't we? I think the solution last
> time was to make sure that the __weak function is never in the same
> compilation unit as a call to it.

good, will try have another one for test.

YH
