Return-Path: <linux-kernel-owner+w=401wt.eu-S1753438Ab0AITcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab0AITcW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 14:32:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440Ab0AITcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 14:32:22 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:41940 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab0AITcV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 14:32:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=brJdYc0GcHooaznSNTiI1Vc78BgWauqNbQ3ddCWkvAuRm3w9lFf/xmhEWT/Edes7Rj
         XZBjt6dFTCUJILMNIybpWVFxFjXycKeDsRDA2czBarWnXRbObQ7AtjG5izfNOJ4qkAfO
         rVYaFrF1IZeBgy3vgk+6boq9tYykCezxrqrJc=
MIME-Version: 1.0
In-Reply-To: <20100109191025.GK4757@const.famille.thibault.fr>
References: <bd8e30a41001091057t97f90abgffe9cca329ace477@mail.gmail.com>
	 <20100109191025.GK4757@const.famille.thibault.fr>
Date: Sat, 9 Jan 2010 11:32:19 -0800
Message-ID: <bd8e30a41001091132m611a2054i3ed4098111e005cb@mail.gmail.com>
Subject: Re: Linux Serial Performance
From: "Paul G. Allen" <pgallen@gmail.com>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       "Paul G. Allen" <pgallen@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, as far as I know. Same code on both systems. The embedded device
operates at 115200, 8N1, no flow control. It uses RPC/SLIP protocol
for commands and data. They talk to each other, but the Linux system
just takes forever to send the data.

PGA

On Sat, Jan 9, 2010 at 11:10 AM, Samuel Thibault
<samuel.thibault@ens-lyon.org> wrote:
> Paul G. Allen, le Sat 09 Jan 2010 10:57:48 -0800, a écrit :
>> In all cases, the profiler shows the serial Tx
>> to be about 20x faster (twenty times) on Windows XP than in Linux.
>
> Did you properly set the serial port speed?
>
> Samuel
>



-- 
Paul G. Allen
Random Logic Consulting
www.randomlogic.com
