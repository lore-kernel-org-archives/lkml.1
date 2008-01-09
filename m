Return-Path: <linux-kernel-owner+w=401wt.eu-S1754291AbYAIBck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbYAIBck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 20:32:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756680AbYAIBc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 20:32:26 -0500
Received: from mu-out-0910.google.com ([209.85.134.190]:40393 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404AbYAIBcZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 20:32:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Vp4SahVpEM/k53XZqd1PEEpaizKEpo1zPbpwjrElbbm+v9Oq1IhCK9nCKIDW8pJKXKx/kSY5tCPAdL+G2n/iCs8/VTfSHxjCUKoULSOWmbzAOjsVwqOrSiEmpPg6JxxJ+USnCbh0PZzVR2809zZRwfrtZcB/NN0Ll05za9G9T3w=
Message-ID: <3aa654a40801081732y4a658d96x2498b5cbbd22bb60@mail.gmail.com>
Date: Tue, 8 Jan 2008 17:32:20 -0800
From: "Avuton Olrich" <avuton@gmail.com>
To: "=?ISO-8859-1?Q?J.A._Magall=F3n?=" <jamagallon@ono.com>
Subject: Re: Linux 2.6.24-rc7
Cc: "Linux-Kernel," <linux-kernel@vger.kernel.org>
In-Reply-To: <20080108015012.2e518dd4@werewolf>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org>
	 <20080108015012.2e518dd4@werewolf>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 7, 2008 4:50 PM, J.A. Magallón <jamagallon@ono.com> wrote:
> HI all...
>
> On Sun, 6 Jan 2008 14:19:16 -0800 (PST), Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
> >
> > It's been two weeks since rc6, but let's face it, with xmas and new years
> > (and birthdays) in between, there hasn't actually been a lot of working
> > days, and the incremental patch from -rc6 is about half the size of the
> > one from rc5->rc6.
> With this kernel I'm getting frequent temporary freezes (system comes
> back responsive after a minute or so...). I see this in dmesg:
>
> ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata3.00: cmd ca/00:08:67:10:18/00:00:00:00:00/e2 tag 0 dma 4096 out
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata3.00: status: { DRDY }
> ata3: soft resetting link
> ata3.00: configured for UDMA/133
> ata3: EH complete

Reminds me of my 2.6.24 regression bug:
http://bugzilla.kernel.org/show_bug.cgi?id=9393
-- 
avuton
--
 Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
