Return-Path: <linux-kernel-owner+w=401wt.eu-S1762693AbYBLNXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762693AbYBLNXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 08:23:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757460AbYBLNXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 08:23:43 -0500
Received: from an-out-0708.google.com ([209.85.132.248]:60983 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564AbYBLNXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 08:23:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qynb1ADnL/yrZP+HGdJCh1TbXEf8JLVaxSLle3Kznbu0xzADZQyr5T8H73+GVBuBU9c0gvRgYWwGV0JkxdwZb59ZVUMTI0QiqjOhSjklHo2t8JqmzxXmZcpAbPnqv7GSI3N4Q5B5GrD/h+CIJPYEtUaY0oUQLulfs7orJCOYmQs=
Message-ID: <b4292e150802120523o7e44500as9be841618805e54e@mail.gmail.com>
Date: Tue, 12 Feb 2008 11:23:40 -0200
From: "Adolfo R. Brandes" <arbrandes@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: USB HID: Missing keys on Gyration Media Center Universal Remote Control
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0802112115580.7699@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b4292e150712280848h36a5bbf5k76e121168e8bfd12@mail.gmail.com>
	 <Pine.LNX.4.64.0801171420400.15647@twin.jikos.cz>
	 <b4292e150801180901wfb55577kc884276622bc869e@mail.gmail.com>
	 <b4292e150801180958v43350590pc6ed4683bfc478ab@mail.gmail.com>
	 <Pine.LNX.4.64.0802112115580.7699@twin.jikos.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Jiri!

The symptoms remain after the patch (sleep key repeats endlessly, tv
key does nothing).  I'm going to post the debug output in a while, but
before I do, it might be relevant that there were a couple of typos in
the patch which I had to fix to compile ("intpu_event" function
doesn't exist; missing "{" on second if statement).  Also, I got these
warnings:

drivers/hid/hid-input.c: In function 'hidinput_hid_event':
drivers/hid/hid-input.c:1045: warning: suggest parentheses around
comparison in operand of &
drivers/hid/hid-input.c:1046: warning: suggest parentheses around
comparison in operand of &
drivers/hid/hid-input.c:1047: warning: suggest parentheses around
comparison in operand of &
drivers/hid/hid-input.c:1056: warning: suggest parentheses around
comparison in operand of &
drivers/hid/hid-input.c:1057: warning: suggest parentheses around
comparison in operand of &

Could these be throwing the patch off?

Thanks,
Adolfo
