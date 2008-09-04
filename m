Return-Path: <linux-kernel-owner+w=401wt.eu-S1754262AbYIDX7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbYIDX7w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 19:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbYIDX7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 19:59:43 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:55172 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbYIDX7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 19:59:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ujw3JtWcqB4z0clWrIvJKLKW9LQMZtS5hMU8HuSsuC6L8ZmYdjpk7pbPVbFWqhGrZz
         nVYQxE6WE1c3o7MkJjU/iCGydkSwdLLvMIDBpBEcwrhy0PBRi2t2kRDDPp+p5c54/qXn
         VtfBWxT+x3SLBTmjdK0w7k+rQADEL+/LPr5PY=
Message-ID: <1df1788c0809041659i3b3a8fb4sa5c44b74976f9a73@mail.gmail.com>
Date: Thu, 4 Sep 2008 20:59:40 -0300
From: "=?UTF-8?Q?Br=C3=A1ulio_Barros_de_Oliveira?=" <brauliobo@gmail.com>
To: "Volker Armin Hemmann" <volker.armin.hemmann@tu-clausthal.de>
Subject: Re: reiserfs do_journal_end unnecessary hd wake up?
Cc: reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200809050154.00318.volker.armin.hemmann@tu-clausthal.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <loom.20080904T211127-782@post.gmane.org>
	 <1df1788c0809041632h726fff6cq2eacd86076215017@mail.gmail.com>
	 <1df1788c0809041647n5f5e4d64yaa2f47d3302494fe@mail.gmail.com>
	 <200809050154.00318.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m84Nxudq014983

hello volker,
running tree command on /tmp i couldn't associate any file withkonsole. that's the result[braulio@brauliopresto tmp]$ tree.|-- kde-root [error opening dir]`-- kde4-braulio    |-- kde-braulio    |   |-- 28165-cm81.skz    |   |-- 86714-PicoNet.skz    |   |-- closeditems    |   |-- konqueror-crash-X31257.log    |   |-- konqueror-crash-X31258.log    |   |-- konqueror-crash-X31259.log    |   |-- konqueror-crash-X31262.log    |   |-- konqueror-crash-X31265.log    |   `-- ksycoca -> /var/tmp/kdecache-braulio/ksycoca    `-- ksocket-braulio        |-- KSMserver__0        |-- kdeinit-:0        |-- kdeinit4__0        |-- kdeinit__0        |-- klauncherMT3820.slave-socket        |-- klauncherT31205.slave-socket        `-- klaunchergALyma.slave-socket
5 directories, 15 files
regards,brÃ¡ulio
On Thu, Sep 4, 2008 at 8:54 PM, Volker Armin Hemmann<volker.armin.hemmann@tu-clausthal.de> wrote:> On Friday 05 September 2008, BrÃ¡ulio Barros de Oliveira wrote:>> just found out! it is konsole, unbelievable! going to file a bug>> report right now.>> again, thank you very much for the support.>> brÃ¡ulio>> let me guess - konsole writes to a temp file in /tmp containing the backlog?> That is not a bug but a feature. You can 'save' you some trouble by putting> /tmp on a tempfs. 256mb should be enough.> --> To unsubscribe from this list: send the line "unsubscribe reiserfs-devel" in> the body of a message to majordomo@vger.kernel.org> More majordomo info at  http://vger.kernel.org/majordomo-info.html>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
