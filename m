Return-Path: <linux-kernel-owner+w=401wt.eu-S1755455AbYDJCJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbYDJCJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 22:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbYDJCJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 22:09:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51836 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088AbYDJCJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 22:09:36 -0400
Message-ID: <47FD76C0.4010603@zytor.com>
Date: Wed, 09 Apr 2008 19:09:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Kasper Sandberg <lkml@metanurb.dk>
CC: Ingo Molnar <mingo@elte.hu>, Matti Aarnio <matti.aarnio@zmailer.org>,
       Zhao Forrest <forrest.zhao@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       discuss@x86-64.org, linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com,
       ak@suse.de
Subject: Re: Does Linux have plan to support memory hole remapping?
References: <ac8af0be0804090054w47f48ddel387d80a0331d16e1@mail.gmail.com>	 <87iqyro3rc.fsf@basil.nowhere.org>	 <20080409083700.GU3700@mea-ext.zmailer.org>	 <20080409085440.GB32466@elte.hu> <1207787687.30698.97.camel@localhost>
In-Reply-To: <1207787687.30698.97.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kasper Sandberg wrote:
> A somewhat related question is.. How come linux does not(as i understand
> it) support talking to the chipsets to do these things? wouldnt this
> also give other benefits, such as being able to more precisely control
> interrupts and stuff?

Sure.  Plus, it's virtually guaranteed to crash or corrupt your system 
if you try to do anything which requires ACPI or SMM.

	-hpa
