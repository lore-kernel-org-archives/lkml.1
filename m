Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab0AaXpT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 18:45:19 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:53894 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab0AaXpR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 18:45:17 -0500
MIME-Version: 1.0
In-Reply-To: <1f9bac08.1a5266d6.4b66012a.5a11a@o2.pl>
References: <1f9bac08.1a5266d6.4b66012a.5a11a@o2.pl>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 1 Feb 2010 00:45:01 +0100
Message-ID: <ac3eb2511001311545j4abe0da3x58db0152caca845e@mail.gmail.com>
Subject: Re: [regression 2.6.33 rc3-rc5] sata_nv and no /dev files
To: =?UTF-8?B?QmFydMWCb21pZWogWmltb8WE?= <uzi18@o2.pl>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 31, 2010 at 23:16, Bartłomiej Zimoń <uzi18@o2.pl> wrote:
> cat /proc/partitions shows partitions but fstab cant mount because no /dev/sdxx files.
> Have chacked on rc4 and rc5 and dont rememmber if rc3 is affected, but it could.
> rc1 is abs ok.

What does:
  grep . /sys/class/block/*/dev
print?

Kay
