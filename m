Return-Path: <linux-kernel-owner+w=401wt.eu-S1753167AbYLCPfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbYLCPfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 10:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbYLCPff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 10:35:35 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:23857 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbYLCPfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 10:35:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=CSYCO6t3dQiXsuV/h00+ATZN33i/N6+lJPv5LvKV9141plihtmRoaef6eW81ec9LLe
         TM/AiT6lptZ72KmAcPbs++BCqOwe3zYMGycRWLtxaICHVUoL87fbiQLoJYgPXiguxQlB
         LJtSOXlt9aK3ZIDyKjP9e5oUypb6yz8WOll4U=
Message-ID: <4936A73E.7060508@gmail.com>
Date: Wed, 03 Dec 2008 16:35:26 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] Char: n_tty, include module.h
References: <1228307338-18467-1-git-send-email-jirislaby@gmail.com>	<20081203124300.3f03dec8@lxorguk.ukuu.org.uk>	<4936A320.3050801@gmail.com> <20081203153351.1a1c054c@lxorguk.ukuu.org.uk>
In-Reply-To: <20081203153351.1a1c054c@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox napsal(a):
> On Wed, 03 Dec 2008 16:17:52 +0100
> Jiri Slaby <jirislaby@gmail.com> wrote:
> 
>> On 12/03/2008 01:43 PM, Alan Cox wrote:
>>> On Wed,  3 Dec 2008 13:28:58 +0100
>>> Jiri Slaby <jirislaby@gmail.com> wrote:
>>>
>>>> Since we are using EXPORT_SYMBOL, we should include linux/module.h
>>>>
>>>> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
>>> NAK
>>>
>>> n_tty doesn't use EXPORT_SYMBOL.
>> Sure it does. Maybe the patch didn't come to you yet. Will repost to akpm as a
>> ldisc-n_tty-export-all-n_tty-ldisc-methods.patch fix
> 
> And that patch isn't going in either. Ask Andrew to drop it instead. If
> the rest of the PPS stuff goes in then I'll redo that part of the n_tty
> stuff differently and cleanly.

Fair enough. Andrew, could you?
