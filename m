Return-Path: <linux-kernel-owner+w=401wt.eu-S1756622AbYIDTq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbYIDTq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 15:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbYIDTqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 15:46:16 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:59515 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbYIDTqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 15:46:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cKdYb2RZMoOdKLS7i1R0LVAmhWlwexpBbU2zgMBniya5P71ou4Off0qUYq0BtPSObZ
         w1m1lMTZlwI7JgMPZpjZME0Gg6+dq1rrczNnrsr00cx/jUXxR0uv7h7sGFgYrJofGQqZ
         f2IVDiSOAxxFP2YNxlQHFNokO32KNEXN9/Klk=
Message-ID: <1df1788c0809041246s3b6fb559y2fd12a6eaf912535@mail.gmail.com>
Date: Thu, 4 Sep 2008 16:46:13 -0300
From: "=?UTF-8?Q?Br=C3=A1ulio_Barros_de_Oliveira?=" <brauliobo@gmail.com>
To: Mat <jackdachef@gmail.com>
Subject: Re: reiserfs do_journal_end unnecessary hd wake up?
Cc: reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <loom.20080904T155515-782@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <loom.20080904T155515-782@post.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m84JkVdq012473

Thanks for your response Mat.
I've tried what you said, and it doesn't make no difference at all. Ican hear the clicks, on a completly idle system, every 30 seconcs(more or less). Here is my mtab:
[root@brauliopresto braulio]# cat /etc/mtab/dev/sda2 / reiserfs rw,commit=540 0 0none /dev ramfs rw 0 0none /proc proc rw 0 0none /sys sysfs rw 0 0none /dev/pts devpts rw 0 0none /dev/shm tmpfs rw 0 0/dev/sda5 /mnt/arquivos reiserfs rw,commit=540 0 0none /mnt/tmpfs tmpfs rw,size=2g 0 0/proc /opt/arch32/proc none rw,bind 0 0/proc/bus/usb /opt/arch32/proc/bus/usb none rw,bind 0 0/dev /opt/arch32/dev none rw,bind 0 0/dev/pts /opt/arch32/dev/pts none rw,bind 0 0/dev/shm /opt/arch32/dev/shm none rw,bind 0 0/sys /opt/arch32/sys none rw,bind 0 0/tmp /opt/arch32/tmp none rw,bind 0 0/home /opt/arch32/home none rw,bind 0 0/mnt /opt/arch32/mnt none rw,bind 0 0/mnt/arquivos /opt/arch32/mnt/arquivos none rw,bind 0 0
brÃ¡ulio
On Thu, Sep 4, 2008 at 12:57 PM, Mat <jackdachef@gmail.com> wrote:> Hi BrÃ¡ulio,>> does mounting the partition(s) with setting the commit-interval to something> higher, e.g. commit=120 or commit=600 make a change ?>> Regards>> Mat>>> --> To unsubscribe from this list: send the line "unsubscribe reiserfs-devel" in> the body of a message to majordomo@vger.kernel.org> More majordomo info at  http://vger.kernel.org/majordomo-info.html>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
