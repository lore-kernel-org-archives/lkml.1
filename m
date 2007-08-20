Return-Path: <linux-kernel-owner+w=401wt.eu-S1761509AbXHTQDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761509AbXHTQDn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 12:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761080AbXHTQCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 12:02:44 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:5567 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761030AbXHTQCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 12:02:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=iG4XvcmiytQWt3MgBx/AaTAhyy9d1QlQ/RZwwaiGMvHYpw8iZHjyl8dRXGXOtmrygmA4DjvMaFK/nO11PZoV/2euj+9PPhvUKECaIQ99npKd2oiw/LalyZ/+TlOVBlYesdi85F7PrdQK7Ie2dQqR2TAhTiPmMuwec8rMsc5xhv8=
Message-ID: <46C9BB09.30102@googlemail.com>
Date: Mon, 20 Aug 2007 18:02:17 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-alpha@vger.kernel.org,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Bob Tracy <rct@gherkin.frus.com>, linux-usb-devel@lists.sourceforge.net,
       Greg KH <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>, Dan Zwell <dzwell@gmail.com>,
       Florin Iucha <florin@iucha.net>, Roman Jarosz <kedgedev@centrum.cz>,
       kvm-devel@lists.sourceforge.net, Avi Kivity <avi@qumranet.com>,
       Paolo Ornati <ornati@fastwebnet.it>
Subject: Re: [2/2] 2.6.23-rc3: known regressions with patches v2
References: <46C9BA30.9020101@googlemail.com>
In-Reply-To: <46C9BA30.9020101@googlemail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.23-rc3
with patches available.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

List of Aces

Name                    Regressions fixed since 21-Jun-2007
Adrian Bunk                            9
Andi Kleen                             5
Linus Torvalds                         5
Andrew Morton                          4
Al Viro                                3
Cornelia Huck                          3
Jens Axboe                             3
Tejun Heo                              3



Alpha

Subject         : 2.6.23-rc3 won't boot on alpha
References      : http://lkml.org/lkml/2007/8/14/487
Last known good : ?
Submitter       : Bob Tracy <rct@gherkin.frus.com>
Caused-By       : ?
Handled-By      : ?
Patch           : http://lkml.org/lkml/2007/8/14/259 ?
Status          : patch available



USB

Subject         : USB hard disk broken in 2.6.23-rc3
References      : http://bugzilla.kernel.org/show_bug.cgi?id=8892
Last known good : ?
Submitter       : Roman Jarosz <kedgedev@centrum.cz>
Caused-By       : ?
Handled-By      : Alan Stern <stern@rowland.harvard.edu>
Patch           : http://bugzilla.kernel.org/attachment.cgi?id=12432
Status          : patch was suggested

Subject         : USB hard disk problem due to "usb-storage: implement autosuspend" patch
References      : http://lkml.org/lkml/2007/8/9/329
Last known good : ?
Submitter       : Dan Zwell <dzwell@gmail.com>
Caused-By       : Alan Stern <stern@rowland.harvard.edu>
                  commit 8dfe4b14869fd185ca25ee88b02ada58a3005eaf
Handled-By      : Alan Stern <stern@rowland.harvard.edu>
Patch           : http://lkml.org/lkml/2007/8/10/195
Status          : patch available



Virtualization

Subject         : WARNING: at arch/x86_64/kernel/smp.c:379 smp_call_function_single()
References      : http://lkml.org/lkml/2007/8/10/117
Last known good : ?
Submitter       : Paolo Ornati <ornati@fastwebnet.it>
Caused-By       : Avi Kivity <avi@qumranet.com>
                  commit cec9ad279b66793bee0b5009b7ca311060061efd
Handled-By      : Avi Kivity <avi@qumranet.com>
Patch           : http://lkml.org/lkml/2007/8/19/38
Status          : patch available



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
