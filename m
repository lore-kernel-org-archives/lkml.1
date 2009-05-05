Return-Path: <linux-kernel-owner+w=401wt.eu-S932273AbZEEKpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273AbZEEKpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 06:45:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932131AbZEEKoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 06:44:20 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:55377 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932107AbZEEKoT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 06:44:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ELeWjbkevNe0dbSeUJdNQQGspQNoaAWYq1vnk4d70rq107CkVwk+FJnC72q82C7q2r
         SNlw3yd7Tv74vczQT6F22PBoyDo+2A0KmbOKjetvulsjP4EqyjC3B9bVt5Imui/cCX0u
         ZqUVi7RIKrruobbgAlXJXLb00KMIS2EV+TQps=
MIME-Version: 1.0
In-Reply-To: <20090504.182628.216265620.wl@gnu.org>
References: <20090503.132958.227862405.wl@gnu.org>
	 <20090504.182628.216265620.wl@gnu.org>
Date: Tue, 5 May 2009 20:44:18 +1000
Message-ID: <21d7e9970905050344x2a92f9c6l8569b68bff905370@mail.gmail.com>
Subject: Re: some kernel issues
From: Dave Airlie <airlied@gmail.com>
To: Werner LEMBERG <wl@gnu.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 5, 2009 at 2:26 AM, Werner LEMBERG <wl@gnu.org> wrote:
>
> [kernel 2.6.30-rc4-14-vanilla from openSuSE factory on top of
> openSuSE 11.1]
>
>
> With my 945GM intel graphics card, I don't get TTYs which I could
> switch to with Ctrl-Alt-Shift-F1, for example, after X has started.
> Only F7 to switch back to graphics mode works fine.  In particular, I
> don't see any boot messages at start-up.  This has worked fine with a
> previous kernel like 2.6.27.21.
>
> Are there new boot parameters to add or is this a bug?  It seems that
> `vga=0x31a' fails (which openSuSE's yast installer provides) since
> without it I can see boot messages.
>
> BTW, for `vga=0x31a' I get
>
>  Console: colour dummy device 80x25
>
> in the log file, while without this parameter I get
>
>  Console: colour VGA+ 80x25

Make sure you haven't enabled kernel mode setting.

CONFIG_DRM_I915_KMS

Dave.

>
>
>    Werner
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
