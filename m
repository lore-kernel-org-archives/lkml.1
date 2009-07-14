Return-Path: <linux-kernel-owner+w=401wt.eu-S1755885AbZGNShY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbZGNShY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 14:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754355AbZGNShY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 14:37:24 -0400
Received: from mail-yx0-f184.google.com ([209.85.210.184]:37548 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbZGNShX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 14:37:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Crncx1ykKJnLmNcPPH9IKgSA6bHci2+HPdwcC+alOeF50+tkJFce2h5CEoaqyWxoB+
         LQtVsQ6GE756I+WS4hfJOG3e+ru1pOejz87rZPRLUtxrYb28A3Yfqze4ReCkMm/cqpFN
         OZSsNFcgE/XInLBzwwekbz6lgGizSV38giDVQ=
MIME-Version: 1.0
In-Reply-To: <20090714.113348.155881037.davem@davemloft.net>
References: <cb0375e10904010840n1543a890w9039465d0f80ffcc@mail.gmail.com>
	 <20090404.170539.148727646.davem@davemloft.net>
	 <ce0170d90907141017h732c2cd7ja5990303093b6edd@mail.gmail.com>
	 <20090714.113348.155881037.davem@davemloft.net>
Date: Tue, 14 Jul 2009 15:37:22 -0300
Message-ID: <ce0170d90907141137o6bcc9cc6iacbb82e5bbc28753@mail.gmail.com>
Subject: Re: [PATCH 1/1] Tell linkwatch about new interfaces
From: Sergio Luis <eeeesti@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: amluto@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 3:33 PM, David Miller<davem@davemloft.net> wrote:
> From: Sergio Luis <eeeesti@gmail.com>
> Date: Tue, 14 Jul 2009 14:17:21 -0300
>
>> is this patch incorrect, though? with the linkwatch_fire_event() call,
>> the rfc2863 operstate will be set for everyone at device register
>> time.
>
> The issue is dumb drivers that do not manage their link state
> at all.  We want them to always have their links up, from the
> moment they are registered.
>
> This is especially important for virtual devices.
>

I see. I will try to take a look at the driver in question, then. Thanks.
