Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbYIDC4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbYIDC4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 22:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397AbYIDC4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 22:56:07 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:43175 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbYIDC4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 22:56:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HEFwWSXSk0Sih+oTvOfGDgt+UVgy6+uJ1YZvAHU2HNnV2h2xRZ/IEjNJF+tvDy9CkI
         3/xcI3hKSu4HNONTl90NodJQQa5MzVhNJfzmGxiqRsKbh4XaEB4N65DUXBGoXuIadwVJ
         TncW0TDU8q4NmHlh6Am7uj8glZFLLtPZ2DSPM=
Message-ID: <1df1788c0809031956r2dad6a58l4be82d370b09f870@mail.gmail.com>
Date: Wed, 3 Sep 2008 23:56:03 -0300
From: "=?UTF-8?Q?Br=C3=A1ulio_Barros_de_Oliveira?=" <brauliobo@gmail.com>
To: reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: reiserfs do_journal_end unnecessary hd wake up?
In-Reply-To: <1df1788c0809031953p22bbbb2cy6dd0d8bbb8339872@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <1df1788c0809031953p22bbbb2cy6dd0d8bbb8339872@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m842uMdq032665

hello,
this is my very first post here. please correct me if necessary.
i'm pretty paranoic with energy save with my laptop. a good way tosave it, is to enable APM for the HD.that's where I see maybe reiserfs is doing something wrong. evenkilling almost every process and not running X, do_journal_end keepsappearing on powertop and the hard disk keeps waking up and sleeping,something you can notice by the noisy clicks.
is this behaviour really right?is there any way to avoid these wakeup (almost 2watts powersave)?
system: archlinux with kernel 2.6.26.3 and standard reiserfs 3.6 fs.
thankx in advance,brÃ¡ulioÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
