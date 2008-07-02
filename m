Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbYGBQt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbYGBQt0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 12:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbYGBQtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 12:49:18 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:4188 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbYGBQtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 12:49:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=AZ9ehlxj+GXe31rE7bAL2yfL98dBjtOTdrxkbwjzns/7BzzkmZELPzGdDswPz5qsFl
         5oEstrO+cieUVtmY+Lpd8jyQBq5L6CLKXlltCrO+cWb0t9aYsLvPCtmJ3McYkb141EzA
         yMtXn9LJdnR0Wsvm1/Qz+vLJPsrHYTDRf/LD4=
Message-ID: <86802c440807020949q31c7d039ua5d9a85caf9901f9@mail.gmail.com>
Date: Wed, 2 Jul 2008 09:49:14 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: rb6@duke.edu
Subject: Re: mtrr registers with >= 4GB ram
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.1.10.0807021049580.15549@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LNX.1.10.0807021049580.15549@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 2, 2008 at 7:55 AM, Rann Bar-On <rb6@duke.edu> wrote:
> As documented at https://bugs.launchpad.net/linux/+bug/210780 and
> http://www.rage3d.com/board/showthread.php?t=33821469 (as well as other
> places - google 4gb mtrr bug), the kernel appears to misdetect the mtrr
> registers on many machines with 4gb ram, causing all sorts of issues -
> especially with video drivers in X.  It is possible to rewrite the correct
> registers using a pretty hackish script, but the bug should probably be
> fixed at the kernel level.
>
> Please CC me personally when replying, as I'm not on LKML.  I'd be happy to
> try out patches if such come along :)

please try tip/master
http://people.redhat.com/mingo/tip.git/readme.txt

we have some patches there ...
      x86: mtrr cleanup for converting continuous to discrete layout, v8
      x86: mtrr cleanup for converting continuous to discrete layout v8 - fix
      x86: mtrr cleanup for converting continuous to discrete - auto detect v4
      x86: mtrr cleanup for converting continuous to discrete layout - fix #2

YH
