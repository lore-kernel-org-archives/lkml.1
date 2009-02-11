Return-Path: <linux-kernel-owner+w=401wt.eu-S1757329AbZBKAVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbZBKAVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 19:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755815AbZBKAVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 19:21:35 -0500
Received: from mail-ew0-f26.google.com ([209.85.219.26]:41975 "EHLO
	mail-ew0-f26.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbZBKAVe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 19:21:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ULWqWGS0vJPVmN5Ur1i1jkkDgBBmTIs5YbTOthdcSC2tiN/Iw4bgu7DXGo/9zRjzOp
         kmu2nPuTV8RkLZpYy2Rh2Y8/mWizSkk+Chys37E6+CB00VufI5wPPRDEzG2uVl4jfYhm
         P4nViJZdiK3DvX80/zvxEyKJxNYG1gBMO3rpA=
MIME-Version: 1.0
In-Reply-To: <499213CD.6080903@tremplin-utc.net>
References: <1234309249-13672-1-git-send-email-giuseppe.bilotta@gmail.com>
	 <499211D0.3090705@tremplin-utc.net>
	 <cb7bb73a0902101551o30dde0aesaeba399f1ab732af@mail.gmail.com>
	 <499213CD.6080903@tremplin-utc.net>
Date: Wed, 11 Feb 2009 01:21:32 +0100
Message-ID: <cb7bb73a0902101621r56224b46id9ab59dfe9501e3c@mail.gmail.com>
Subject: Re: [PATCHv2] lis3lv02d: support both one- and two-byte sensors
From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
To: =?ISO-8859-1?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>
Cc: Pavel Machek <pavel@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[removed git from the cc because that was a mistake]

On Wed, Feb 11, 2009 at 12:54 AM, Éric Piel <Eric.Piel@tremplin-utc.net> wrote:
> BTW, now that this is working. Could you double check the correct axes set
> up. In particular, is it x_inverted or y_inverted, and what about z axis...

Now that we have the 8 vs 16 bit mess sorted out, I re-checked and
there my sensor definitely has the X (first) axis inverted, so the
one-liner patch I sent at the beginning is still valid, at least as
far as my laptop is involved. It might be that different dv5 Pavilions
have different sensors though, which will make it quite harder to sort
out.

I'd be interested in hearing from the other user (the one reporting
inverted Y): rather than checking neverball, could he use plain jstest
and see if the results match the Documentation or not?


-- 
Giuseppe "Oblomov" Bilotta
