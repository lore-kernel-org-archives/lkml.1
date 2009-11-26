Return-Path: <linux-kernel-owner+w=401wt.eu-S1752040AbZKZFlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbZKZFlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 00:41:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbZKZFlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 00:41:36 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:61657 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbZKZFle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 00:41:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TIHBo00vtcGhDb14tJd6bSUD3zUYfzVeuYQTRiY52TPYuUETDJZ+0NLlOVu5gRrko3
         Jh/RyAITp1Q2WxbmrIyYAdn87R5fyq9F1znJ0XjxTEz1oH2UzHYmIL9jZYwhMiaZ30lW
         gpH/9Btn3rkBP4vBlNyCbkL3gKuGCncuLD2KM=
Date: Wed, 25 Nov 2009 21:41:35 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Jarod Wilson <jarod@wilsonet.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
       Mario Limonciello <superm1@ubuntu.com>, linux-input@vger.kernel.org,
       linux-media@vger.kernel.org, Janne Grunau <j@jannau.net>,
       Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: IR raw input is not sutable for input system
Message-ID: <20091126054135.GG23244@core.coreip.homeip.net>
References: <200910200956.33391.jarod@redhat.com> <200910200958.50574.jarod@redhat.com> <4B0A765F.7010204@redhat.com> <4B0A81BF.4090203@redhat.com> <m36391tjj3.fsf@intrepid.localdomain> <20091123173726.GE17813@core.coreip.homeip.net> <4B0B6321.3050001@wilsonet.com> <1259105571.28219.20.camel@maxim-laptop> <Pine.LNX.4.58.0911241918390.30284@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0911241918390.30284@shell2.speakeasy.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 07:32:42PM -0800, Trent Piepho wrote:
> 
> One thing that could be done, unless it has changed much since I wrote it
> 10+ years ago, is to take the mark/space protocol the ir device uses and sent
> that data to lircd via the input layer.  It would be less efficient, but
> would avoid another kernel interface.  Of course the input layer to lircd
> interface would be somewhat different than other input devices, so
> it's not entirely correct to say another interface is avoided.

No, it would still be completely new interface that just happened to use
input layer as transport. An ordinary program that would just want to
react to play. pause, forward, etc buttons would have no idea what to do
with the data so you'd still need a very specialized library to deal
with the data.

-- 
Dmitry
