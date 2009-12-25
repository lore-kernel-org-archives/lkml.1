Return-Path: <linux-kernel-owner+w=401wt.eu-S1753272AbZLYKoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbZLYKoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 05:44:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbZLYKoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 05:44:23 -0500
Received: from ironport4.lbl.gov ([128.3.41.45]:57190 "EHLO ironport4.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900AbZLYKoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 05:44:22 -0500
X-Ironport-SBRS: 4.5
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmAAAD4mNEuAAykMkWdsb2JhbACbWwEBAQEJCwoHEwW5b4QzBA
X-IronPort-AV: E=Sophos;i="4.47,453,1257148800"; 
   d="scan'208";a="18836831"
Date: Fri, 25 Dec 2009 02:44:20 -0800 (PST)
From: Andrei Gaponenko <andrei.gaponenko@cern.ch>
To: Dave Airlie <airlied@gmail.com>
cc: linux-kernel@vger.kernel.org, Alex Deucher <alexdeucher@gmail.com>,
       Dave Airlie <airlied@redhat.com>
Subject: Re: drm/radeon/kms regression: 2.6.33-rc2 does not boot
In-Reply-To: <21d7e9970912250232uebe337eu520a7fa98d21c293@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0912250241350.11466@x200s>
References: <alpine.LFD.2.00.0912250124410.11466@x200s> <21d7e9970912250146s3e36cb9vcfc12a42445b37a2@mail.gmail.com> <alpine.LFD.2.00.0912250204220.11466@x200s> <21d7e9970912250232uebe337eu520a7fa98d21c293@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-188429421-1261737861=:11466"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-188429421-1261737861=:11466
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Fri, 25 Dec 2009, Dave Airlie wrote:

> On Fri, Dec 25, 2009 at 8:08 PM, Andrei Gaponenko
> <andrei.gaponenko@cern.ch> wrote:
> > On Fri, 25 Dec 2009, Dave Airlie wrote:
> >
> >> On Fri, Dec 25, 2009 at 7:31 PM, Andrei Gaponenko
> >> <andrei.gaponenko@cern.ch> wrote:
> >> > Hello,
> >> >
> >> > One of my systems works fine with 2.6.32, but hangs when trying to
> >> > boot 2.6.33-rc2.  Git bisect says
> >> > 7923c615b811945a9d9f456c92a7a32c34167458 is the first bad commit:
> >> > [...]
> >>
> 
> Did you install the irq firmware from
> http://people.freedesktop.org/~agd5f/radeon_ucode/

That was the problem!  2.6.33-rc2 boots after I installed the
firmware.  Thank you, Dave!

Andrei

Please Cc me directly on replies.

> 
> I need to add a pointer to the Kconfig (just wasn't there when I sent it i).
> 
> Dave.
> 
--0-188429421-1261737861=:11466--
