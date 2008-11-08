Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbYKHQj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbYKHQj2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 11:39:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbYKHQjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 11:39:20 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:54672 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbYKHQjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 11:39:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Q5iz6gDMpgOUHf8yWiZR6FQcqpDmHBxO2eyVkhECblu/Todyp8M0Qr59XQg23/r8WR
         taq7yRttdEyORmS1EczQb2xQse6RL4Hw3hyHwvR7/SGreW40K1QrqLZy+6erUvd1LUql
         g0EOST118GWqdTqCPvE2n51cfKm64NiCWxqyM=
Message-ID: <b2cc26e40811080839i387e5e94o519a5d1ff0086379@mail.gmail.com>
Date: Sat, 8 Nov 2008 17:39:17 +0100
From: "Olaf van der Spek" <olafvdspek@gmail.com>
To: mathias.schnarrenberger@gmx.de
Subject: Re: security: delete BIOS password in keyboard buffer during kernel bootup
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200811081100.03966.mathias.schnarrenberger@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200811081100.03966.mathias.schnarrenberger@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 8, 2008 at 11:00 AM, Mathias Schnarrenberger
<mathias.schnarrenberger@gmx.de> wrote:
> Hi,
>
> I'm using a BIOS password in my notebook (nc6120 from HP). Recently I noticed that the HP BIOS doesn't clean the keyboard buffer after the password was correctly entered. I know that this is rather a BIOS thing but I assume that other BIOSes also don't clean the BIOS keyboard ring buffer (at adress from 0x0000041E up to 0x0000043D). Since after the kernel boot up the BIOS Keyboard ISR is deactivated no one cares about the data in the keyboard buffer. So, the BIOS password is kept in the buffer.
>
> So, I think it would be good if the kernel clears the keyboard buffer during boot up (at least in x86-based systems) to protect the users password. I don't know anything about EFI-based systems and other architectures.
> Because I'm not sure where to implement the code to delete the keyboard buffer in the kernel, I can't make a proper patch. Possibly one of you can do this ;)

What if my BIOS stores some critical info at that memory address?
I don't think the kernel is the right place to work around this issue.
