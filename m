Return-Path: <linux-kernel-owner+w=401wt.eu-S1755622AbZCHE2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622AbZCHE2d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 23:28:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754250AbZCHE2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 23:28:25 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:15741 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbZCHE2Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 23:28:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=QAkXFZcAxP6Y2AIbZ2W4oyQSXAbT1PtzUD5QNaHWlZxRW/4lsvZNYsQQgR57Lbp4yN
         x2ZVlMJtlEi3FZVrOg1eq/hlSZHbgRRgvTgiKqnB3r7xMtGn2G2lwkEq5LWlz/6yqyu2
         Rj0OL0kbJGLRG+o83oGGgsXr0ksMUBft5lXuI=
MIME-Version: 1.0
In-Reply-To: <20090306110949.GC6493@sirena.org.uk>
References: <1236326010-683-1-git-send-email-cooloney@kernel.org>
	 <1236326010-683-5-git-send-email-cooloney@kernel.org>
	 <20090306110949.GC6493@sirena.org.uk>
Date: Sun, 8 Mar 2009 12:28:22 +0800
X-Google-Sender-Auth: 3ef16f6cdeca7e28
Message-ID: <386072610903072028i64865773w4e05598c7ff49ac9@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH 4/5] ASoC: Blackfin: drop pointless casts due 
	to dma updates
From: Bryan Wu <cooloney@kernel.org>
To: Mark Brown <broonie@sirena.org.uk>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 6, 2009 at 7:10 PM, Mark Brown <broonie@sirena.org.uk> wrote:
> On Fri, Mar 06, 2009 at 03:53:29PM +0800, Bryan Wu wrote:
>> From: Mike Frysinger <vapier.adi@gmail.com>
>>
>> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
>> Signed-off-by: Bryan Wu <cooloney@kernel.org>
>> ---
>>  sound/blackfin/bf53x_sport.c |   55 ++++++++++++++++++-----------------------
>>  1 files changed, 24 insertions(+), 31 deletions(-)
>
> Mainline doesn't have a sound/blackfin directory at all as far as I can
> tell so this patch doesn't apply?  The only mainline support I can see
> for blackfin audio is sound/soc/blackfin which only has a generic
> bf5xx-sport file.  A similar cleanup was done there a while ago.
>

Oh, god. Sorry, my script sent out this in a mess. Please ignore this one

Thanks a lot
-Bryan
