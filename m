Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879Ab0AXP4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab0AXP4P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 10:56:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847Ab0AXP4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 10:56:14 -0500
Received: from outbound-mail-111.bluehost.com ([69.89.18.7]:35989 "HELO
	outbound-mail-111.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753415Ab0AXP4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 10:56:14 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:Subject:Message-ID:From:To:Cc:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=NCe1E0zkj7ApodUdfyU490nj9bTnZMuhzI5mWxU4aTQ0f+dGznYgll8+hQHtWBA2Ivx9MxZbMl3vQyjpXpCYv8HRQnAmHV4jm4nKFw4njeZ2NhIHzQUpQug7zBnzXf8a;
Date: Sun, 24 Jan 2010 07:56:38 -0800
Subject: Re: [PATCH 1/2] PM / Runtime: Add sysfs switch for disabling device
 run-time PM (rev. 2)
Message-ID: <59qes3i0orxy6yfyqhf7q34x.1264348598355@email.android.com>
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=utf-8
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.209.15.60 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o0OFv354022824



"Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>On Saturday 23 January 2010, Alan Stern wrote:>> On Sat, 23 Jan 2010, Rafael J. Wysocki wrote:>> >> > Hmm, OK.>> > >> > Of course, if the driver decides to leave disable_depth > 0, the user still>> > won't be able to do anything about that, but if I understand correctly, you>> > want drivers to have the option to use pm_runtime_forbid() initially, right>> > after pm_runtime_enable(), so that the user space can turn the runtime PM>> > on if desired via sysfs.>> > >> > That makes sense.  I have a usage case for that myself. :-)>> > >> > Updated patch is appended.>> >> It looks good.>> >> Acked-by: Alan Stern <stern@rowland.harvard.edu>>>Thanks!>>Rafael>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
