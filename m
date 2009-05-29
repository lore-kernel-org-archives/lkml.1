Return-Path: <linux-kernel-owner+w=401wt.eu-S1762152AbZE2Pzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762152AbZE2Pzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 11:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761809AbZE2PzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 11:55:06 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:56598 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761608AbZE2PzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 11:55:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=yG7gn8DDa+SHV67JkW447iWgRv0lbBAFaUajnkMx9ISaTQp7QeXkgqgwtiBaPcuszP
         IGwQuZil0zLzV2JGj/D4ru7esJ2NXT/cfAOCMnLMoGYluznXDkEm/IHVblDrBHKkygOL
         kFQxGQGYZyx38nVK9Jo60YBIroNOjSMG9smw0=
Message-ID: <4A20051C.6080507@gmail.com>
Date: Fri, 29 May 2009 17:54:04 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1pre) Gecko/20090525 SUSE/3.0b2-10.1 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Peter Botha <peterb@goldcircle.co.za>
Subject: Re: [PATCH 1/1] Char: mxser, fix ISA board lookup
References: <1243612393-2111-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1243612393-2111-1-git-send-email-jirislaby@gmail.com>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2009 05:53 PM, Jiri Slaby wrote:
> From: "Peter Botha" <peterb@goldcircle.co.za>
> 
> There's a bug in the mxser kernel module that still appears in the 2.6.29.4
> kernel.
> 
> mxser_get_ISA_conf takes a ioaddress as it's first argument, by passing the
> not of the ioaddr, you're effectively passing 0
> which means it won't be able to talk to an ISA card.
> I have tested this, and removing the ! fixes the problem.
> 
> Cc: "Peter Botha" <peterb@goldcircle.co.za>

It would be good if you could add your Signed-off-by here.

> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
