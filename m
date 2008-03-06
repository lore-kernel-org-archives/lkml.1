Return-Path: <linux-kernel-owner+w=401wt.eu-S935552AbYCFU6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935552AbYCFU6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 15:58:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762906AbYCFU5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 15:57:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46485 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759731AbYCFU5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 15:57:54 -0500
Date: Thu, 6 Mar 2008 21:57:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Pawel Plociennik <paplociennik@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24] chroot= as a new kernel parameter
Message-ID: <20080306205736.GA22756@elte.hu>
References: <200803060001.38432.paplociennik@gmail.com> <47CF79E4.3030107@zytor.com> <20080306102712.GE13391@elte.hu> <47D00B16.6040004@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D00B16.6040004@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0088]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> It's useless because it's exactly and trivially replaceable with:
>
> 	init=/path/to/any/sbin/chroot /newroot /sbin/init

ok, i didnt realize that this was possible. Ah ... i see, 
init/main.c:init_setup() is special and picks the whole boot parameter 
string up to the end, right? So init= is the only multi-parameter 
init-parameter.

	Ingo
