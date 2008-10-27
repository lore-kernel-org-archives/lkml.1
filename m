Return-Path: <linux-kernel-owner+w=401wt.eu-S1752825AbYJ0JZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbYJ0JZZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 05:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbYJ0JZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 05:25:13 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:58139 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbYJ0JZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 05:25:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=N+9z8vje+B48/1iB/rkaw8ugwgd4K7JEJv+pDhsrjP+Pw1e7wX32tHU5cclIRYhgWY
         C3iWvfVrafR7zT80O+WnMfQ3A+SbKZYhfQTd5zUmNnl2GPC/ONxC0xwGgXykqhndUONh
         X9kBwuwiDs+PUtpe+8pPXR9sSp73JmJUaTyHc=
Message-ID: <fe810cf0810270225p27ab00br474b46ddb275d1f5@mail.gmail.com>
Date: Mon, 27 Oct 2008 12:25:10 +0300
From: "Alexander Belyakov" <abelyako@googlemail.com>
To: "=?UTF-8?Q?Toralf_F=C3=B6rster?=" <toralf.foerster@gmx.de>
Subject: Re: build issue #569 for v2.6.28-rc1-5-g23cf24c : 'struct jffs2_sb_info' has no member named 'wbuf_ofs'
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
In-Reply-To: <200810261652.18700.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <200810261652.18700.toralf.foerster@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m9R9PTdq026760

On Sun, Oct 26, 2008 at 6:52 PM, Toralf FÃ¶rster <toralf.foerster@gmx.de> wrote:> Hello,>> the build (.config attached) failed, make ends with :> ...>  CC      fs/jffs2/nodemgmt.o> fs/jffs2/nodemgmt.c: In function 'jffs2_find_nextblock':> fs/jffs2/nodemgmt.c:265: error: 'struct jffs2_sb_info' has no member> named 'wbuf_ofs'> fs/jffs2/nodemgmt.c:265: error: 'struct jffs2_sb_info' has no member> named 'wbuf_len'> fs/jffs2/nodemgmt.c:266: error: 'struct jffs2_sb_info' has no member> named 'wbuf_ofs'> make[2]: *** [fs/jffs2/nodemgmt.o] Error 1> make[1]: *** [fs/jffs2] Error 2> make: *** [fs] Error 2>> The build was made with :> $>make randconfig; make clean; make>
There is a commit in MTD git fixing this build issuehttp://git.infradead.org/mtd-2.6.git?a=commit;h=f04de505e3fa322728d1a851e08bf7060b117743
Thank you,Alexanderÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
