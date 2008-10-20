Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270AbYJTX4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbYJTX4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 19:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbYJTX4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 19:56:00 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:54732 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbYJTX4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 19:56:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=aa+mSQYdrwiODKEti2WHMjKFpaVv+6rw3SjJhfpTM62siJwLF38jly+n6nqXJBAyNK
         Ibtu9S9dzSbsTgTgwVpPsyasK9uchUeOj/O3nLl5QXzJ9xpAvWIPOAjOO/Z5aW4xqX72
         k1q/pmswL8j+/zhrEwRZ9xM4PjMeF5FGfmpdo=
Message-ID: <86802c440810201655gf0fdc60veb957db3b427dd73@mail.gmail.com>
Date: Mon, 20 Oct 2008 16:55:59 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: tip is broken with NOHZ: restart tick device from irq_enter()
Cc: "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0810210118380.3301@apollo>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440810201601s78a605f4l98624eedbc108d33@mail.gmail.com>
	 <alpine.LFD.2.00.0810210118380.3301@apollo>
X-Google-Sender-Auth: 5ba9b4f20b995f71
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 4:22 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Mon, 20 Oct 2008, Yinghai Lu wrote:
>
>> all my servers are broken with following commit.
>
> Can you please explain what exactly is broken ?
>

system will hang after

initcall pcibios_assign_resources+0x0/0x88 returned 0 after 732 msecs
calling  inet_init+0x0/0x1f2 @ 1
NET: Registered protocol family 2


YH
