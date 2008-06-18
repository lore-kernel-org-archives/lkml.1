Return-Path: <linux-kernel-owner+w=401wt.eu-S1753557AbYFRLee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbYFRLee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 07:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbYFRLeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 07:34:25 -0400
Received: from japan.chezphil.org ([77.240.5.4]:2462 "EHLO japan.chezphil.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786AbYFRLeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 07:34:24 -0400
X-Greylist: delayed 2809 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Jun 2008 07:34:24 EDT
To: "Paul Collins" <paul@burly.ondioline.org>
Cc: <jkosina@suse.cz>, <linux-input@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
       "Marcel Holtmann" <marcel@holtmann.org>,
       "Phil Endecott" <phil_tuhck_endecott@chezphil.org>
Date: Wed, 18 Jun 2008 11:47:32 +0100
Subject: Re: [PATCH] [RESEND] fix HID quirks for aluminium apple wireless
	keyboards
Message-ID: <1213786052191@dmwebmail.dmwebmail.chezphil.org>
In-Reply-To: <87mylj2ggu.fsf@burly.wgtn.ondioline.org>
References: <87mylj2ggu.fsf@burly.wgtn.ondioline.org>
X-Mailer: Decimail Webmail 3alpha16
MIME-Version: 1.0
Content-Type: text/plain; format="flowed"
From: "Phil Endecott" <phil_tuhck_endecott@chezphil.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Collins wrote:
> "Phil Endecott" <phil_tuhck_endecott@chezphil.org> writes:
>
>> Why do you set HID_QUIRK_APPLE_NUMLOCK_EMULATION ?  I don't know what
>> that quirk really does, but since these keyboards have neither a
>> numeric keypad nor a numlock key I can't see any benefit.
>
> From a quick skim of the code (drivers/hid/hid-input.c) it looks like
> it's supposed to allow a laptop-style numeric keymap mapping to be
> enabled with F6, but I can't make it do anything here.  Perhaps it is
> best removed after the hid-bus merge, otherwise there'll be different
> quirks in different places for the same devices.

The general policy seems to be to make these keyboards behave the same 
on Linux as they do with Macs.  My guess is that they don't have any 
numeric keypad emulation feature on Macs - can anyone confirm?  In that 
case it shouldn't be enabled.  Personally, I wouldn't like to 
accidentally press F6 (e.g. pressing all the fn keys in turn looking 
for the "right one"), and then discover that half of the 
letter/punctuation keys were broken, and have no idea how to "fix" it.


Phil.




