Return-Path: <linux-kernel-owner+w=401wt.eu-S1756654AbXEUQXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbXEUQXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 12:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755140AbXEUQW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 12:22:57 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:21511 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248AbXEUQW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 12:22:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=JXDkphe2TajlYOz4o8Y/7dpc2JqiSAvJqDWHrtTl/Y1MHJ83QtNINlt8p8wR0rIyLJHs7WoBY7OHSuky/pI+d/Ebasee0dQPpMrAchB2uKdgLv9Poe3pronm5vVMuc6k5pNs2Z5plZyax7XM6xSMG/TsKN9xc5atu9QH13sLshU=
Message-ID: <4651C74B.7020108@gmail.com>
Date: Mon, 21 May 2007 18:22:35 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Robert de Rooy <robert.de.rooy@gmail.com>
CC: linux-kernel@vger.kernel.org, alan@redhat.com, bzolnier@gmail.com,
       jgarzik@pobox.com, linux-pcmcia@lists.infradead.org
Subject: Re: libata and legacy ide pcmcia failure
References: <464A0321.3080201@gmail.com> <464C1575.8070005@gmail.com> <464CB7C9.2080807@gmail.com> <46503192.1040300@gmail.com> <4650B9E3.7070409@gmail.com> <46518798.2020808@gmail.com> <4651B66E.6030505@gmail.com> <4651B834.3060702@gmail.com> <4651C4A1.6000101@gmail.com>
In-Reply-To: <4651C4A1.6000101@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert de Rooy wrote:
> Hmm, good question. I do not have any other PCMCIA device to test.
> The only other device I have is a Cardbus Wi-Fi adapter without Linux
> support (Marvell). If I insert that adapter lspci seems to list it
> properly, but without resorting to ndiswrapper I have no way of testing
> it. In any case, seeing how Cardbus is PCI based this is probably
> pointless to resolving this issue.
> 
> Would any other log data from the controller initialization or lspci help?

Hmmm... I don't really know much about PCMCIA.  cc'ing linux-pcmcia.

The original thread can be read from the following URL.

  http://thread.gmane.org/gmane.linux.kernel/530099

It seems we're losing interrupts from the CFA device.  Any ideas?

Thanks.

-- 
tejun
