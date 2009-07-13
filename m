Return-Path: <linux-kernel-owner+w=401wt.eu-S932122AbZGMWFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122AbZGMWFI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 18:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757572AbZGMWFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 18:05:07 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:37283 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757206AbZGMWFF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 18:05:05 -0400
MIME-Version: 1.0
In-Reply-To: <20090713202720.GD2569@elf.ucw.cz>
References: <20090629114339.GA25552@elf.ucw.cz>
	 <20090629121023.GD28046@google.com>
	 <20090630102457.GA25802@elf.ucw.cz>
	 <a55d774e0906300338l7743d566k5b463eed3efd1ea1@mail.gmail.com>
	 <20090709101315.GF10937@elf.ucw.cz>
	 <a55d774e0907090406u5e91b5c9r2303b098d0e44988@mail.gmail.com>
	 <20090713202720.GD2569@elf.ucw.cz>
Date: Mon, 13 Jul 2009 15:05:04 -0700
Message-ID: <d6200be20907131505x2ea29585p4bc8babebfc7395a@mail.gmail.com>
Subject: Re: HTC Dream camera support for staging
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Brian Swetland <swetland@google.com>, "Arve Hj??nnev??g" <arve@google.com>,
       Iliyan Malchev <malchev@google.com>,
       kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 13, 2009 at 1:27 PM, Pavel Machek<pavel@ucw.cz> wrote:
...
>> > gpio_matrix: I thought in-tree zaurus keypad driver has recently
>> > became generic enough to almost replace this?
>>

I would recommend using our driver since it allows multiple input
types in the same device. The generic matrix driver may work, but you
will not get the power and camera keys in the same device. The generic
driver also does not yet handle phantom keys, so if you for instance
press right-alt+right-shift+p you will also get 9. Our gpio input
driver also handles the trackball.

I have also seen devices that put the trackball click in the keypad
matrix which means we have to change our gpio input driver to create
multiple input devices. That change would also allow the two keypads
on the G1 to be separate input devices which would allow both menu
keys to report KEY_MENU.

-- 
Arve Hjønnevåg
