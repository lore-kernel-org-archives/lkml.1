Return-Path: <linux-kernel-owner+w=401wt.eu-S1753000AbZJTXVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbZJTXVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 19:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbZJTXVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 19:21:44 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:45364 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbZJTXVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 19:21:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=xb2znD135NztgVOz+kV07jXhWEE1VnKcgo5FEJm75swxqas0BxESx+rBV3xv8iKI0j
         5RjMl5CUyBjpaCz91a7mzyDfxLfGEHnbQZk1Orb4wXDuljw5b22xs9ks8vW+KyW9OFV+
         5l6N1ty0QQkuhGLTFEXHLw4DGHahHaFh5TdI8=
MIME-Version: 1.0
In-Reply-To: <e3511b0c31dd03889a221c947dec2c80.squirrel@webmail.xs4all.nl>
References: <4ADE2773.8020507@gmail.com> <e3511b0c31dd03889a221c947dec2c80.squirrel@webmail.xs4all.nl>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 21 Oct 2009 08:21:28 +0900
Message-ID: <43e72e890910201621t6691cf08kb62478fcba2fe097@mail.gmail.com>
Subject: Re: No support for Fritz!WLAN USB N2.4
To: Ed Vaessen <evaessen@xs4all.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 21, 2009 at 7:10 AM, Ed Vaessen <evaessen@xs4all.nl> wrote:
> To my surprise I found that it seems that the driver for Fritz!WLAN USB
> N2.4 is not longer supported. At least, the last tarballs I got do not
> compile them anymore. Their code is still there but no module with the
> name ar9170 is built. Modules from the same group, like ath5k and ath9k
> are built.
> Am I missing something?

What kernel are you on? ar9170 only builds on >= 2.6.29 due to some
difficulty in backporting some USB code which ar9170 uses.

  Luis
