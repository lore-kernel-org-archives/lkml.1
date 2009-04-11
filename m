Return-Path: <linux-kernel-owner+w=401wt.eu-S1759493AbZDKXKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759493AbZDKXKk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 19:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759175AbZDKXKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 19:10:31 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:54402 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758947AbZDKXKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 19:10:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=NN2jEgY9GLOxKk7fT+y1fNkcQ96jHHYcQeKFMzbWAhQ26e7N+c1vwln3KD+v4GI8cP
         AXO/Qh55olUGEbV3fckvho5QlleE28St6uc/DwOUP1ssQoR/EAXWcwju2UQNTSOxxKsb
         z60tWciMktyNnbt+oA6xpIOqNYdb2le7cMRA4=
Message-ID: <49E12378.8070200@gmail.com>
Date: Sun, 12 Apr 2009 01:10:48 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090310)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux.kernel" <linux-kernel@vger.kernel.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.30-rc1 (latest git): thinkpad-acpi: cannot control brightness
 with hotkeys
References: <49E10684.5090101@gmail.com> <20090411150555.8b13ed18.akpm@linux-foundation.org> <49E11FD0.9040403@gmail.com>
In-Reply-To: <49E11FD0.9040403@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2009 12:55 AM, Niel Lambrechts wrote:
> Could it be related to this commit?
>
> commit 0e501834f8c2ba7de2a56e332d346dcf4ac0b593
> Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Date:   Sat Apr 4 04:25:53 2009 +0000
>
>     thinkpad-acpi: rework brightness support
>
>     Refactor and redesign the brightness control backend...
>   
Okay, please bear with me (I'm a git novice) but when I did

'git revert 0e501834f8c2ba7de2a56e332d346dcf4ac0b593'

and recompiled I was still unable to control the brightness with the
hotkeys...

Niel


