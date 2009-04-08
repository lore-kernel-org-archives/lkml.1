Return-Path: <linux-kernel-owner+w=401wt.eu-S1764180AbZDHKRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764180AbZDHKRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 06:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764153AbZDHKRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 06:17:06 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:62181 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764032AbZDHKRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 06:17:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Qg4rbp/TGWydHRjrZ01jgULHzYB17+InmPEcp0GP92ZUb8cEyOWOUxDOXny6B4Dqjb
         Cow70VfjuK5Mn1GeL9SY9nZxqtUim8FsA3n5QUaRU/wrjrYurYB19lN0t/cmhNhBsFbc
         jUFgh7FC6o1eCLXFgnZ5gChJwM0vYPIrPH1xU=
MIME-Version: 1.0
In-Reply-To: <1237823287-12734-9-git-send-email-philipp.reisner@linbit.com>
References: <1237823287-12734-1-git-send-email-philipp.reisner@linbit.com>
	 <1237823287-12734-2-git-send-email-philipp.reisner@linbit.com>
	 <1237823287-12734-3-git-send-email-philipp.reisner@linbit.com>
	 <1237823287-12734-4-git-send-email-philipp.reisner@linbit.com>
	 <1237823287-12734-5-git-send-email-philipp.reisner@linbit.com>
	 <1237823287-12734-6-git-send-email-philipp.reisner@linbit.com>
	 <1237823287-12734-7-git-send-email-philipp.reisner@linbit.com>
	 <1237823287-12734-8-git-send-email-philipp.reisner@linbit.com>
	 <1237823287-12734-9-git-send-email-philipp.reisner@linbit.com>
Date: Wed, 8 Apr 2009 15:47:03 +0530
Message-ID: <807b3a220904080317gfd1720cv951781abdea8c9b@mail.gmail.com>
Subject: Re: [PATCH 08/12] DRBD: receiver
From: Nikanth K <nikanth@gmail.com>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
       Nikanth Karthikesan <knikanth@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n38AI4qu028451

On Mon, Mar 23, 2009 at 9:18 PM, Philipp Reisner<philipp.reisner@linbit.com> wrote:
<snip>
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  /* peer not (yet) available, network problem */> + Â  Â  Â  Â  Â  Â  Â  case ECONNREFUSED: case ENETUNREACH:> + Â  Â  Â  Â  Â  Â  Â  case EHOSTDOWN: Â  Â case EHOSTUNREACH:> +#if 0> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  DBG("%s failure ignored, err = %d\n",> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  what, err);> +#endif
Unused code.

> +#if 0> + Â  Â  Â  Â  Â  Â  Â  else {> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  DBG("%s failure ignored, err = %d, not Disconnecting\n",> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  what, err);> + Â  Â  Â  Â  Â  Â  Â  }> +#endif
Unused code.

ThanksNikanthÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
