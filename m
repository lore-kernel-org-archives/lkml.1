Return-Path: <linux-kernel-owner+w=401wt.eu-S1753853AbYIVUcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbYIVUcv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 16:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbYIVUcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 16:32:42 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:17920 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbYIVUcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 16:32:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=AcRJIcnAHjZskC/HAtnRjhQk7rBJcutZLDSPoiZg4r9Uoh4J9/YGURWDwuehwWsesD
         ZtbDaYxSt7+5IhiHkyWFp536vjwmzxOwrFOvIRu4BkLw0t/BNnECeulcsUtf+BvzLMkX
         xdfkt8SFDbppRJG8c415P4Lz5sj/NlP8E2/aE=
Message-ID: <5d9b736f0809221332q21dea0a1lb8159b64391ee978@mail.gmail.com>
Date: Mon, 22 Sep 2008 22:32:40 +0200
From: "Michal Januszewski" <michalj@gmail.com>
To: "=?UTF-8?Q?Bruno_Pr=C3=A9mont?=" <bonbons@linux-vserver.org>
Subject: Re: [Linux-fbdev-devel] [PATCH] fbdev: don't allow to set a video mode via vga= if FB doesn't support it
Cc: "Krzysztof Helt" <krzysztof.h1@poczta.fm>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080922220054.4e74c099@neptune.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <20080921210219.GC21215@spock.one.pl>
	 <20080922214747.c8bc57eb.krzysztof.h1@poczta.fm>
	 <20080922220054.4e74c099@neptune.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m8MKWsdq021001

On Mon, Sep 22, 2008 at 22:00, Bruno PrÃ©mont <bonbons@linux-vserver.org> wrote:
> This looks pretty much the same as what I requested some time ago:>> http://bugzilla.kernel.org/show_bug.cgi?id=8062>> Would need to check -mm archives for the actual patch.>> Don't remember why it did not make it to mainline...
Well, the bug and the mm fix [1] are about a similar, yet slightly differentissue than the one I'm trying to fix with my patch (note that the issuereported in the bug is currently fixed in the kernel, but the actual fixis differrent than the one in -mm due to x86 boot code refactoringthat took place since then).
My patch fixes the case where the framebuffer is enabled, but none ofthe drivers support boot-time video mode setting, whereas the oldpatch fixed the case where it was possible to set a video mode eventhough the kernel didn't contain the framebuffer layer.
[1] http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc2/2.6.21-rc2-mm1/broken-out/fbdev-ignore-vesa-modes-if-framebuffer-is-disabled.patch
Best regards,-- Michal Januszewski, Gentoo Linux Developerhttp://people.gentoo.org/spockÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
