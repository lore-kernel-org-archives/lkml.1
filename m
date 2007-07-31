Return-Path: <linux-kernel-owner+w=401wt.eu-S934782AbXGaVll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934782AbXGaVll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 17:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934425AbXGaVlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 17:41:21 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:51690 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763023AbXGaVlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 17:41:20 -0400
Message-ID: <46AFABE8.7050107@gmail.com>
Date: Tue, 31 Jul 2007 23:38:48 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: kriko <kristjan.ugrin@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Reboot hang
References: <op.twci6be2atcbto@linux.site> <46AF9DC8.7080103@gmail.com> <op.twclwllkatcbto@linux.site>
In-Reply-To: <op.twclwllkatcbto@linux.site>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2007 11:27 PM, kriko wrote:

> On Tue, 31 Jul 2007 22:38:32 +0200, Rene Herman <rene.herman@gmail.com> 
> wrote:
> 
>> Does it matter at all if you add "reboot=b" (other options w, c, h) as 
>> a comand line parameter?
> 
> None of that parameters worked for me. It seems they do have some 
> effects (judging by bios information screen), but they don't fix the 
> problem.

Shame.

> I hope you understood where exactly it hangs (I don't know how is this 
> screen called), so here is a quick shot of screen:
> http://files.myopera.com/kriko/files/Photo0003.jpg

"Summary screen" will do, but yes, I understood. Perhaps your BIOS isn't 
fond of the state the Linux drivers leaves your DVD-ROM at. Judging by your 
"nv_pata", you are probebly usiing the pata (pata_amd) driver, not the old 
IDE driver?

Does it boot through if you disable booting from the DVD-ROM?

Rene.
