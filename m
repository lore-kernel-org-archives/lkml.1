Return-Path: <linux-kernel-owner+w=401wt.eu-S1752273AbYKQM7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbYKQM7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 07:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbYKQM7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 07:59:05 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:20606 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbYKQM7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 07:59:03 -0500
Message-ID: <ac3eb2510811170459j13a13c0cs1b649a67e6901b7f@mail.gmail.com>
Date: Mon, 17 Nov 2008 13:59:01 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "=?UTF-8?Q?Manfred_Preu=C3=9Fig?=" <PreussigM@web.de>
Subject: Re: Just a small question on new kernels
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <49216E17.32742.2039A2@PreussigM.web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <49216E17.32742.2039A2@PreussigM.web.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id mAHCxLdq017890

On Mon, Nov 17, 2008 at 13:13, Manfred PreuÃŸig <PreussigM@web.de> wrote:> since I haven't a subscription yet for the list please send all> answers to me in addition.>> I only want to know one thing: Is there any plan to 'let the older> ide driver die' in kernel or have they done it at all yet? I use an> ide disk with more than 15 partitions due to historic reasons and> don't want to change this. With the kernel I use at the moment I can> add a kernel param (hwprobe=-modules.pata) to prevent the newer> driver from handling the disk and so it works but what's about newer> kernels and what is planned for the future?>> many thanks for any answer (or a link to an answer I overlooked in> archive or FAQ)
sd* block devices, or libata drivers will not have a limit on partitions:  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=3e1a7ff8a0a7b948f2684930166954f9e8e776fe
Kayÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
