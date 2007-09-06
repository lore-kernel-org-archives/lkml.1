Return-Path: <linux-kernel-owner+w=401wt.eu-S1756900AbXIFMbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbXIFMbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 08:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754452AbXIFMba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 08:31:30 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:42525 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899AbXIFMb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 08:31:29 -0400
Date: Thu, 6 Sep 2007 14:31:28 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: James Pearson <james-p@moving-picture.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Anton Arapov <aarapov@redhat.com>,
       Guy Streeter <guy.streeter@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 4096 byte limit to /proc/PID/environ ?
In-Reply-To: <46DEE0C9.1000402@moving-picture.com>
Message-ID: <Pine.LNX.4.64.0709061429331.25942@fbirervta.pbzchgretzou.qr>
References: <4474B7DB.8000304@moving-picture.com> <200605242029.k4OKTn9C031700@terminus.zytor.com>
 <447EF58C.6000605@moving-picture.com> <52dd17640708150954q798d137cn1b07739785917c5b@mail.gmail.com>
 <46C33700.1060605@zytor.com> <46D6CBED.4040301@moving-picture.com>
 <h87in5sgal.fsf@pepelac.englab.brq.redhat.com> <46DE6196.3050605@zytor.com>
 <46DEE0C9.1000402@moving-picture.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 5 2007 18:00, James Pearson wrote:
>
> OK, here is the patch (without the long line) against 2.6.23-rc5 - what else
> needs to be done to get it committed?

Someone has to point out CodingStyle, so I'll ruin everyone's day now :)

> +static ssize_t environ_read(struct file * file, char __user * buf,
                                            ^                   ^
be gone these spaces.

> +       while (count > 0) {
> +               int this_len, retval;
> +
> +               this_len = mm->env_end - (mm->env_start + src);
> +
> +               if (this_len <= 0) {
> +                       break;
> +               }

Be gone, braces.



