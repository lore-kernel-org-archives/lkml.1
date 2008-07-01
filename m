Return-Path: <linux-kernel-owner+w=401wt.eu-S1760691AbYGAU3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760691AbYGAU3X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 16:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755150AbYGAU3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 16:29:07 -0400
Received: from gw.goop.org ([64.81.55.164]:45717 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758950AbYGAU3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 16:29:06 -0400
Message-ID: <486A938D.3080009@goop.org>
Date: Tue, 01 Jul 2008 13:29:01 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Sean Young <sean@mess.org>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org
Subject: Re: Regression: boot failure on AMD Elan TS-5500
References: <20080616121138.GA51097@atlantis.8hz.com> <200806162327.34912.rusty@rustcorp.com.au> <48566C88.6000702@goop.org> <20080616161944.GA53539@atlantis.8hz.com> <20080630214347.GA57988@atlantis.8hz.com> <4869558A.9020907@goop.org> <48695871.8000805@zytor.com> <48695F88.9080905@goop.org> <48696167.6050000@zytor.com> <20080701195942.GA76608@atlantis.8hz.com> <486A9257.1050302@zytor.com>
In-Reply-To: <486A9257.1050302@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Not really.  In particular, I really don't want to add something that 
> is even remotely likely to break on other platforms, and a fence 
> instruction is relatively recent.

I wonder if a cpuid would do the trick?  Do we still support cpuid-less 
processors?

    J
