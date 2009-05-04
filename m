Return-Path: <linux-kernel-owner+w=401wt.eu-S1757154AbZEDRmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154AbZEDRmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 13:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754479AbZEDRmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 13:42:10 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:53318 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbZEDRmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 13:42:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vAV9Y02tIEhDawhpX6Wz5IyIWzSlFOUBFBrbxaKRxGnviRA1hE2v3htYFcqVMRdWnh
         1bl6slKgk5yzqHEkT6toZ2eljwn7qJxcvOghWNnYqKAtGQBi/UvwQ09cVKTmYan2w5QG
         CbSYWoAdIYNK+t3xo8FMximbsA4FsVwmyE7+s=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0905041209570.10610@vinegar-pot.mit.edu>
References: <1241121253-32341-1-git-send-email-tabbott@mit.edu>
	 <20090501213118.GA28126@uranus.ravnborg.org>
	 <alpine.DEB.1.10.0905011916530.10966@vinegar-pot.mit.edu>
	 <20090502220132.GA4130@uranus.ravnborg.org>
	 <20090504142732.GA8237@uranus.ravnborg.org>
	 <alpine.DEB.1.10.0905041209570.10610@vinegar-pot.mit.edu>
Date: Mon, 4 May 2009 13:42:08 -0400
Message-ID: <8bd0f97a0905041042g71af324eo1d38e35799836c86@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] macros for section name cleanup
From: Mike Frysinger <vapier.adi@gmail.com>
To: Tim Abbott <tabbott@mit.edu>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>,
       Anders Kaseorg <andersk@mit.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n44HgQqu022517

On Mon, May 4, 2009 at 12:32, Tim Abbott wrote:> On Mon, 4 May 2009, Sam Ravnborg wrote:>> +#define RW_DATA_SECTION(page_align, readmostly_align, cache_align,>>   inittask_align) \>> +     . = ALIGN(PAGE_SIZE);                                           \>> +     .data : AT(ADDR(.data) - LOAD_OFFSET) {                         \>> +             DATA_DATA                                               \>> +             CONSTRUCTORS                                            \>> +             NOSAVE_DATA                                             \>> +             PAGE_ALIGNED_DATA(page_align)                           \>> +             READMOSTLY_DATA(readmostly_align)                       \>> +             CACHELINE_ALIGNED_DATA(cache_align)                     \>> +             INIT_TASK(inittask_align)                               \>> +     }>> How did you pick the order of the sections here?  I would think that to> pack the .data section efficiently, you'd want to sort by alignment> requirements so that e.g. all the at-least-page aligned sections are> adjacent (INIT_TASK and the page-aligned sections are separated by some> much smaller aligments here).
if this were actually the case, there should of course be some /*comments */ above the define explaining that the order wasntarbitrarily pulled like a rabbit from an orifice.  if you'rescratching your head, then there's going to be plenty more people whonever ask but treat it like untouchable voodoo.-mike���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
