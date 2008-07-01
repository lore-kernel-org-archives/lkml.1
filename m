Return-Path: <linux-kernel-owner+w=401wt.eu-S1761102AbYGAUmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761102AbYGAUmo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 16:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754814AbYGAUmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 16:42:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57715 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027AbYGAUmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 16:42:35 -0400
Message-ID: <486A95F1.3080007@zytor.com>
Date: Tue, 01 Jul 2008 13:39:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Sean Young <sean@mess.org>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org
Subject: Re: Regression: boot failure on AMD Elan TS-5500
References: <20080616121138.GA51097@atlantis.8hz.com> <200806162327.34912.rusty@rustcorp.com.au> <48566C88.6000702@goop.org> <20080616161944.GA53539@atlantis.8hz.com> <20080630214347.GA57988@atlantis.8hz.com> <4869558A.9020907@goop.org> <48695871.8000805@zytor.com> <48695F88.9080905@goop.org> <48696167.6050000@zytor.com> <20080701195942.GA76608@atlantis.8hz.com> <486A9257.1050302@zytor.com> <486A938D.3080009@goop.org>
In-Reply-To: <486A938D.3080009@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> H. Peter Anvin wrote:
>> Not really.  In particular, I really don't want to add something that 
>> is even remotely likely to break on other platforms, and a fence 
>> instruction is relatively recent.
> 
> I wonder if a cpuid would do the trick?  Do we still support cpuid-less 
> processors?

Yes, we do.  Worst case, we could bypass it, but I'd like to understand 
what the real constraint is, here.

	-hpa
