Return-Path: <linux-kernel-owner+w=401wt.eu-S1755898AbYDCXPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbYDCXPG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 19:15:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbYDCXOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 19:14:55 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:15787 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbYDCXOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 19:14:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qmnT+Q8HQkY6zgQQ4ar8xUh/3iTxrKOA29ckWi7fsx3rTpsoOl9tg6rrKdrUyUJERinMVKmNd1wE8SnLxLZ0xrwGOjoDAcd0vxiP0GF0THYUdrCXmtrfLJHAi83FdFL6p7IrH070o8Ym1TfXpQaivg27oKnWlgfJ7hDXcIhBgSQ=
Message-ID: <dd18b0c30804031614vf072230g894ab03e4f44034c@mail.gmail.com>
Date: Thu, 3 Apr 2008 23:14:52 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Stefan Schweizer" <genstef@gentoo.org>
Subject: Re: suspend
Cc: "Oliver Neukum" <oliver@neukum.org>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <e79639220804030153q46fa82c7jb79bedbe88b30df7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30804012331oc548416k113e492d7dc9c189@mail.gmail.com>
	 <200804030932.27993.oliver@neukum.org> <ft21pb$oc3$1@ger.gmane.org>
	 <200804031029.26635.oliver@neukum.org>
	 <e79639220804030153q46fa82c7jb79bedbe88b30df7@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello with doing some more testing on suspending the macbook pro;
 like in the other posts about appletouch, it seems to me to be a
problem with X,  one test appletouch was able to have scroll
functionality due to the event number staying the same. Hopefully with
the latest version coming  this issue will be resolved.  With running
a test on wpa_supplicant. when shutting internet off then suspending
the system wpa_supplicant seems to be unresponsive, but if you leave
wpa_supplicant connected the only issue I see is  when wpa_supplicant
does a rekey.

with streaming music xmms seems to do alright, the music will play
whatever is left in the memory then reconnect itself, with watching
T.V. through gmplayer it seems to loose connectivity as well as
watching T.V. through flash.

With watching a DVD gmplayer seems to crash everytime upon wakeup.

with the isight it seems rmmod uvcvideo and modprobe uvcvideo does the
trick, but SELinux will reject the device due to the event number
changing.
With the bluetooth mighty mouse hid2hci --tohci does the trick, but
I'm not satisfied with that, how to keep the device on hci?
after a wakeup.
regards;
               Justin P. Mattock


On Thu, Apr 3, 2008 at 8:53 AM, Stefan Schweizer <genstef@gentoo.org> wrote:
> >  On second thought, this should be fixed by usb persist if the appletouch
>  >  driver supported reset_resume. Would you be willing to test a kernel patch
>  >  that implements reset_resume in the appletouch driver?
>
>  Sure, I would love to have this fixed :-)
>
>  best regards,
>  -Stefan
>
>
> --
>  To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Justin P. Mattock
