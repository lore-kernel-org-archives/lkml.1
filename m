Return-Path: <linux-kernel-owner+w=401wt.eu-S1755299Ab0AMPgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab0AMPgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 10:36:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755239Ab0AMPgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 10:36:43 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:49730 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032Ab0AMPgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 10:36:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=wz7e2EGsoZrcYES+HRzs9sEnvc28IoujizQGPXiJmOteZgUPjVCpX4sbQ8Xer72dD1
         Q5imWP6FleixmTFWi4m0pZsHSx0fdyf2rTmr/qk8ExIZGKk7SxcUAWYlmNb5Zbgehsg/
         ZCHoROE4Wvfd496phb6u2e4kGGxoRTqO4xqpA=
Message-ID: <4B4DE887.6030602@gmail.com>
Date: Wed, 13 Jan 2010 10:36:39 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       =?UTF-8?B?SWxwbyBKw6RydmluZW4=?= <ilpo.jarvinen@helsinki.fi>,
       Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v4] tcp: harmonize tcp_vx_rcv header length assumptions
References: <4B49D001.4000302@gmail.com> <4B4DA4F4.6060007@gmail.com> <20100113115617.GA24818@basil.fritz.box>
In-Reply-To: <20100113115617.GA24818@basil.fritz.box>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> It's difficult to benchmark this code, but did you check that the code 
> shrinks after applying this patch at least?
> 
Good question.  Only on a gross scale with ls -l.

Before: 332612
After:  332384

I've just spent an hour Googling and then trying to decipher the make file
looking for a standard way to generate the -S (.s output), but no joy.

What make command would you suggest to get the interleaved asm?
