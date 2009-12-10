Return-Path: <linux-kernel-owner+w=401wt.eu-S1761108AbZLJQo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761108AbZLJQo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 11:44:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761096AbZLJQo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 11:44:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58113 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761092AbZLJQo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 11:44:28 -0500
Message-ID: <4B21246B.4070804@zytor.com>
Date: Thu, 10 Dec 2009 08:40:11 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
CC: David Miller <davem@davemloft.net>, xiyou.wangcong@gmail.com,
       x86@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       mingo@redhat.com
Subject: Re: [PATCH] irq: handle irq0 special only on x86
References: <1260350401-9858-1-git-send-email-u.kleine-koenig@pengutronix.de> <2375c9f90912090128k70f54ee1n99421caa81c53a8f@mail.gmail.com> <20091209.014151.140337246.davem@davemloft.net> <20091210082452.GA2420@pengutronix.de>
In-Reply-To: <20091210082452.GA2420@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2009 12:24 AM, Uwe Kleine-König wrote:
> 
> Note, I fully agree to use 0 for NO_IRQ if you have an int-sized value
> that holds either NO_IRQ or a valid irq number.  But in practise I'd not
> recommend to use this idiom.
> 

You're tilting at windmills about something that was settled long ago,
like it or not.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

