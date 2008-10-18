Return-Path: <linux-kernel-owner+w=401wt.eu-S1752113AbYJRJLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbYJRJLb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 05:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbYJRJLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 05:11:24 -0400
Received: from el-out-1112.google.com ([209.85.162.183]:64778 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbYJRJLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 05:11:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gmxr9F1BYkqnqgTXfC1wu//qgpizSnmjghac+wJnYU81tkfmwPiAjVgFqtHYpzx8iw
         1isH2tXs+W1oDEnJAxFIEn/l8Un1BNxx20ry0GIa0XlQXS6GLrzzrnwP/SiCUdHUt+H/
         UCAZ9r/U3siJvinGczWVVEiVEqCaumZPoDGNg=
Message-ID: <21d7e9970810180211l36408eefh23b825965ccb825c@mail.gmail.com>
Date: Sat, 18 Oct 2008 19:11:21 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [git pull] drm patches for 2.6.27-rc1
Cc: "Dave Airlie" <airlied@linux.ie>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
In-Reply-To: <alpine.LFD.2.00.0810171510170.3438@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.0.82.0810172227490.14817@skynet.skynet.ie>
	 <alpine.LFD.2.00.0810171510170.3438@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/18 Linus Torvalds <torvalds@linux-foundation.org>:
>
>
> On Fri, 17 Oct 2008, Dave Airlie wrote:
>>
>> Please pull the 'drm-next' branch from
>> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-next
>
> Grr.
>
> This whole merge series has been full of people sending me UNTESTED CRAP.
>
> So what's the excuse _this_ time for adding all these stupid warnings to
> my build log? Did nobody test this?

The code has been tested on 32 and 64 bit in lots of places, however I
don't generally trawl the Fedora
kernel build logs, and the amount of warnings we have there, new ones
just get lost in the mists..

So its not untested on 64-bit, its just nobody who cared enough saw
the compiler warnings. If linux-next had been
going for the past few weeks someone would have spotted them, I just
got the report yesterday from linux-next after I fed the push request.

Perhaps we all need access to the Ingo compile farm.

Dave.
