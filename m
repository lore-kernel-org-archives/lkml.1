Return-Path: <linux-kernel-owner+w=401wt.eu-S1753499AbXFSNny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbXFSNny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 09:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbXFSNnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 09:43:46 -0400
Received: from styx.suse.cz ([82.119.242.94]:60451 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751359AbXFSNnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 09:43:46 -0400
Date: Tue, 19 Jun 2007 15:44:16 +0200
From: Vojtech Pavlik <vojtech@suse.cz>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jikos@jikos.cz>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stanislav Brabec <sbrabec@suse.cz>
Subject: Re: PATCH: change keycode for scancode e0 32 from 150 to 172
Message-ID: <20070619134416.GL6382@suse.cz>
References: <466F1462.5090008@hhs.nl> <466F1E5C.5090002@zytor.com> <Pine.LNX.4.64.0706131113400.23280@twin.jikos.cz> <466FB80E.7050902@hhs.nl> <Pine.LNX.4.64.0706131131250.23280@twin.jikos.cz> <d120d5000706130645o4b63e9e8mf7606eb682275a0@mail.gmail.com> <46770E66.70506@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46770E66.70506@hhs.nl>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 12:59:50AM +0200, Hans de Goede wrote:
> Dmitry Torokhov wrote:
> >On 6/13/07, Jiri Kosina <jikos@jikos.cz> wrote:
> >>On Wed, 13 Jun 2007, Hans de Goede wrote:
> >>
> >>> Good to hear, so as everyone smees to agree, shall I write a (massive,
> >>> complex, intrusive) patch to fix this, or are there until now silent
> >>> parties that object?
> >>
> >>Well, Dmitry is the one who has final word on this, as it is related to
> >>PS/2 keyboards. Just noticed he is not in CC, added.
> >>
> >
> >Yep, just send me the patch (don't forget to make change to
> >drivers/char/keyboard.c that Vojtech mentioned in other e-mail).
> >
> 
> Here is a patch as promised, attached.
> 
> Thanks & Regards,
> 
> Hans

Patch looks OK (didn't test it, but it seems to do all what's needed).

Acked-by: Vojtech Pavlik <vojtech@suse.cz>


> As discussed by mail change keycode for scancode e0 32 from 150 to 172
> 
> Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>
> diff -ur linux-2.6.22-rc4.orig/drivers/char/keyboard.c linux-2.6.22-rc4/drivers/char/keyboard.c
> --- linux-2.6.22-rc4.orig/drivers/char/keyboard.c	2007-06-16 22:54:47.000000000 +0200
> +++ linux-2.6.22-rc4/drivers/char/keyboard.c	2007-06-18 23:15:27.000000000 +0200
> @@ -1005,8 +1005,8 @@
>  	284,285,309,  0,312, 91,327,328,329,331,333,335,336,337,338,339,
>  	367,288,302,304,350, 89,334,326,267,126,268,269,125,347,348,349,
>  	360,261,262,263,268,376,100,101,321,316,373,286,289,102,351,355,
> -	103,104,105,275,287,279,306,106,274,107,294,364,358,363,362,361,
> -	291,108,381,281,290,272,292,305,280, 99,112,257,258,359,113,114,
> +	103,104,105,275,287,279,258,106,274,107,294,364,358,363,362,361,
> +	291,108,381,281,290,272,292,305,280, 99,112,257,306,359,113,114,
>  	264,117,271,374,379,265,266, 93, 94, 95, 85,259,375,260, 90,116,
>  	377,109,111,277,278,282,283,295,296,297,299,300,301,293,303,307,
>  	308,310,313,314,315,317,318,319,320,357,322,323,324,325,276,330,
> diff -ur linux-2.6.22-rc4.orig/drivers/input/keyboard/atkbd.c linux-2.6.22-rc4/drivers/input/keyboard/atkbd.c
> --- linux-2.6.22-rc4.orig/drivers/input/keyboard/atkbd.c	2007-06-16 22:54:48.000000000 +0200
> +++ linux-2.6.22-rc4/drivers/input/keyboard/atkbd.c	2007-06-18 23:07:24.000000000 +0200
> @@ -89,7 +89,7 @@
>  	  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
>  	217,100,255,  0, 97,165,  0,  0,156,  0,  0,  0,  0,  0,  0,125,
>  	173,114,  0,113,  0,  0,  0,126,128,  0,  0,140,  0,  0,  0,127,
> -	159,  0,115,  0,164,  0,  0,116,158,  0,150,166,  0,  0,  0,142,
> +	159,  0,115,  0,164,  0,  0,116,158,  0,172,166,  0,  0,  0,142,
>  	157,  0,  0,  0,  0,  0,  0,  0,155,  0, 98,  0,  0,163,  0,  0,
>  	226,  0,  0,  0,  0,  0,  0,  0,  0,255, 96,  0,  0,  0,143,  0,
>  	  0,  0,  0,  0,  0,  0,  0,  0,  0,107,  0,105,102,  0,  0,112,
> @@ -111,7 +111,7 @@
>  	 82, 83, 80, 76, 77, 72, 69, 98,  0, 96, 81,  0, 78, 73, 55,183,
>  
>  	184,185,186,187, 74, 94, 92, 93,  0,  0,  0,125,126,127,112,  0,
> -	  0,139,150,163,165,115,152,150,166,140,160,154,113,114,167,168,
> +	  0,139,172,163,165,115,152,172,166,140,160,154,113,114,167,168,
>  	148,149,147,140
>  };
>  


-- 
Vojtech Pavlik
Director SuSE Labs
