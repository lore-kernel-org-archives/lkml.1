Return-Path: <linux-kernel-owner+w=401wt.eu-S1754875AbYH2ICu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbYH2ICu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 04:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754065AbYH2IC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 04:02:27 -0400
Received: from gw.goop.org ([64.81.55.164]:44063 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678AbYH2ICZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 04:02:25 -0400
Message-ID: <48B7AD10.2010704@goop.org>
Date: Fri, 29 Aug 2008 01:02:24 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Hugh Dickens <hugh@veritas.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] x86: check for and defend against BIOS memory	corruption
References: <48B701FB.2020905@goop.org> <b170af450808282320g27dfa2a9mc0e14e27e215ce96@mail.gmail.com> <20080829064540.GA26619@elte.hu> <48B7A377.8010205@goop.org> <20080829073036.GB9232@elte.hu>
In-Reply-To: <20080829073036.GB9232@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Rafał's corruption was definitely non-zero.  I think the corruption is 
>> happening, but it's just not reported.
>>     
>
> i thought we did a check after coming back from resume? That would be a 
> natural place to do the check. (the corruption is suspend/resume related 
> after all, right?)

No, in Rafał's case it happens when he unplugs an HDMI cable.

    J
