Return-Path: <linux-kernel-owner+w=401wt.eu-S1760214AbYAUOkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760214AbYAUOkI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 09:40:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754210AbYAUOj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 09:39:57 -0500
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:38170 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054AbYAUOj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 09:39:56 -0500
Message-ID: <4794ADE0.7070203@keyaccess.nl>
Date: Mon, 21 Jan 2008 15:36:16 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: jidong xiao <jidong.xiao@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Question about set_intr_gate_ist()
References: <4104961b0801202223w1d739365s2bd0ce552a22da19@mail.gmail.com>
In-Reply-To: <4104961b0801202223w1d739365s2bd0ce552a22da19@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21-01-08 07:23, jidong xiao wrote:

>   I know there is set_intr_gate(n,addr) which is used to insert an
> interrupt gate in the n th IDT entry. But I don't know what the usage
> of set_intr_gate_ist()?

The same, while setting the "Interrupt STack" field of the descriptor to 
"ist". This field is a 64-bit only field, implementing a hardware stack 
switch. Look for it in the AMD64 docs.

Rene.
