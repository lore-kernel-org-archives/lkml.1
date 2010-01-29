Return-Path: <linux-kernel-owner+w=401wt.eu-S1756651Ab0A2EDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab0A2EDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 23:03:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756613Ab0A2EDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 23:03:21 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:33588 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756611Ab0A2EDV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 23:03:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=FXHvQdOJTHCmrVoDndKA0mS6gEAidFzLvNqXO8ASh80YHH6cRbfnVCklQCH/pCATi3
         i6zi8f5dZynU3Mi/ATddljI+R3UVgnpw+uZQZ/4+s2JcKKz43MrlY1ETFOayrVkLqffA
         B+xb986urKYZB+tq5l7K7u8CWhGDwOdQ2UPE0=
MIME-Version: 1.0
In-Reply-To: <20100128181240.GA9174@merkur.ravnborg.org>
References: <4B61357A.5080001@windriver.com> <20100128181240.GA9174@merkur.ravnborg.org>
From: Hui Zhu <teawater@gmail.com>
Date: Fri, 29 Jan 2010 12:03:00 +0800
Message-ID: <daef60381001282003q4d43c01dk91c53ec5be17fdf2@mail.gmail.com>
Subject: Re: [PATCH] markup_oops.pl: fix get "No matching code found" when 
	first line of range is the faulting instruction
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Hui Zhu <hui.zhu@windriver.com>, Michal Marek <mmarek@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, ozan@pardus.org.tr,
       Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 02:12, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Thu, Jan 28, 2010 at 02:58:02PM +0800, Hui Zhu wrote:
>> Sorry guys, the prev mail for this patch is ugly.
>> I make a new mail for it.
>
> Random updates to scripts/* historically often go
> in via the kbuild tree, so Michal added.
>
>        Sam
>
> [Kept rest of mail so Michal can see it]
>
>>

Thanks Sam.  And I make a small patch to make get_script.pl can output
Michal Marek.

Hui

Signed-off-by: Hui Zhu <teawater@gmail.com>
---
 MAINTAINERS |    4 ++++
 1 file changed, 4 insertions(+)

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3086,6 +3086,10 @@ L:	autofs@linux.kernel.org
 S:	Maintained
 F:	fs/autofs4/

+KERNEL SCRIPT
+M:	Michal Marek <mmarek@suse.cz>
+F:	scripts/*
+
 KERNEL BUILD
 M:	Michal Marek <mmarek@suse.cz>
 T:	git git://repo.or.cz/linux-kbuild.git for-next
