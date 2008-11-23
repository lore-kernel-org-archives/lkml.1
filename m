Return-Path: <linux-kernel-owner+w=401wt.eu-S1752376AbYKWW3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376AbYKWW3U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 17:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbYKWW3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 17:29:11 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:55876 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbYKWW3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 17:29:10 -0500
Date: 23 Nov 2008 23:28:00 +0100
From: lirc@bartelmus.de (Christoph Bartelmus)
To: jkosina@suse.cz
Cc: jonsmirl@gmail.com
Cc: jrm8005@gmail.com
Cc: linux-kernel@vger.kernel.org
Cc: pavel@suse.cz
Message-ID: <AqQUJV3JjFB@christoph>
In-Reply-To: <alpine.LRH.1.10.0811232128050.26670@twin.jikos.cz>
Subject: Re: In-kernel IR remote control support
User-Agent: OpenXP/4.10.7369 (Linux) (i386)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1/LJi5cZT4QZd3jnqva26s3Xvbx6eJsQLwzgU+
 is5Y51kJ6f2v9H8DdefinxV/bIbAVYe+0AZQTIjgk84UXjDJn3
 lXlnWJ4B2a7FahvS45um2QLdMvdCu3NpANQYDdchxI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

on 23 Nov 08 at 21:33, Jiri Kosina wrote:
> On Sun, 23 Nov 2008, Christoph Bartelmus wrote:

>> You can have LIRC setup to decode all common remote control protocols.
>> It's just a matter of proper packaging and pre-configuration. You don't
>> have to write a single line of code for this (I still have to add uinput
>> support, though, which I probably would have done by now, if I weren't
>> busy writing posts like this).

> Just a question -- how much is the situation different to what we
> currently have for HID devices?
>
> For these, we currently have common code, that is able to handle all the
> "normal" devices by default, that are fully compliant with the HID
> standard.
> For the devices that don't behave that well, we have specialized drivers,
> that use all the generic HID infrastructure to handle the
> standard-compliant behavior of the device and allows the specialized
> drivers to implement only the parts that violate standard.
>
> It's pretty lightweight and seems to work well. Wouldn't this work also
> for LIRC drivers?

No. Unlike with HID devices, with most IR receivers you can use any  
remote. In LIRC we write drivers for the receivers and don't care about  
the remote, which is handled in userspace. The suggested approach would  
move both receiver and remote handling into kernel space (actually only  
part of it because many receivers have userspace drivers, so both receiver  
and remote handling must be done in userspace anyway for these receivers).

Christoph
