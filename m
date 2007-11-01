Return-Path: <linux-kernel-owner+w=401wt.eu-S1759373AbXKAPui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759373AbXKAPui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 11:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755771AbXKAPuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 11:50:23 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:37518 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100AbXKAPuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 11:50:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=DvnP3rhVcgCfmG/+CjYONplhUNH26zwCQBprQIxmNelae9/PF7mwEQBj5Ra9MHrr7f0Pnk5CfgywH35Z9FKQngQW/p6re+TxhlWksuBhQEJHWTHnKL69dNg05axNpG8HjpVoqDyPf2yfpRaXWXjqgMzhrMdXSWkmN9yFObNvvpo=
Message-ID: <4729F5B9.70401@gmail.com>
Date: Thu, 01 Nov 2007 16:50:17 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Char: tty, add tty_schedule_wakeup
References: <14457172322573118772.slaby@karneval.cz>	<15530290543226725036.slaby@karneval.cz> <20071101154847.570d8e96@the-village.bc.nu>
In-Reply-To: <20071101154847.570d8e96@the-village.bc.nu>
X-Enigmail-Version: 0.95.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox napsal(a):
> I think just using tty_wakeup for this ought to be sufficient unless they
> are using the work queue for some kind of serialization of events

Actually this is what I wanted to hear. Going to change those which does it.

thanks,
--js
