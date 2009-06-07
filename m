Return-Path: <linux-kernel-owner+w=401wt.eu-S1755504AbZFGPlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504AbZFGPlk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 11:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753595AbZFGPlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 11:41:32 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:52807 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbZFGPlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 11:41:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:content-type:content-transfer-encoding;
        b=BAPcrFuOZ4Q/m4UyER13JqZ4y2iSBx0j9ePhN0kl20IVg/jWMxINNmbqZjZZueQmzV
         LNMBYhcu9S/4C2JW1CXYSOjwm0xGRaz5d+S/uIJLjjSpa/5m7NCcEvixfKVRZXMUfJtf
         ZuTtE/3OQVs2XMDspPbcRDsqvxS5wyvIHpjGc=
MIME-Version: 1.0
Reply-To: alan-jenkins@tuffmail.co.uk
In-Reply-To: <506D26C038%linux@youmustbejoking.demon.co.uk>
References: <4A2934F5.4050601@tuffmail.co.uk>
	 <506D26C038%linux@youmustbejoking.demon.co.uk>
Date: Sun, 7 Jun 2009 16:41:30 +0100
Message-ID: <9b2b86520906070841v334d8306ha656c95ee4536261@mail.gmail.com>
Subject: Re: [PATCH] eeepc-laptop: enable camera by default
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>,
       Corentin Chary <corentin.chary@gmail.com>,
       acpi4asus-user@lists.sourceforge.net, len.brown@intel.com,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/7/09, Darren Salt <linux@youmustbejoking.demon.co.uk> wrote:
> I demand that Alan Jenkins may or may not have written...
>
>> Btw I've now tested the udev rule, you can just dump this in a new .rules
>> file under /etc/udev/rules.d:
>
>> SUBSYSTEM=="usb", ATTR{idVendor}=="eb1a", ATTR{idProduct}=="2761",
>> ATTR{power/level}="auto"
>
> And a similar line for 05e3:0505, which seems to be working fine here.

Ok.

Hmm, some cameras have input devices (i.e. buttons). In fact, uvcvideo
registers an input device on my EEE even though it has no buttons.  I
think that needs investigating :-(.

It's quite likely that the buttons can stop working when suspended.
And there might be other devices with the same IDs, which have a
button wired up.

Regards
Alan
