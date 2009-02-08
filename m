Return-Path: <linux-kernel-owner+w=401wt.eu-S1754458AbZBHWLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458AbZBHWLV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 17:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbZBHWLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 17:11:09 -0500
Received: from h155.mvista.com ([63.81.120.155]:57761 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753262AbZBHWLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 17:11:08 -0500
Message-ID: <498F5873.1080906@ru.mvista.com>
Date: Mon, 09 Feb 2009 01:10:59 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       rjw@sisk.pl
Subject: Re: [PATCH] libata-sff: fix 32-bit PIO regression
References: <200902082253.07438.sshtylyov@ru.mvista.com> <20090208201125.49326bd2@lxorguk.ukuu.org.uk>
In-Reply-To: <20090208201125.49326bd2@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Alan Cox wrote:

>> swapping bytes to and fro as well by using io*_rep() which shouldn't byte-swap.
>>     
>
> Nice - thats a very sneaky and clean way to do it but probably should be
> commented or someone will "optimise" it one day ..
>   

   OK, I'll recast and repost it -- along with the patch cleaning up the 
corresponding fragment of the 16-bit I/O method.

MBR, Sergei


