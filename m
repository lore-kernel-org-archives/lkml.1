Return-Path: <linux-kernel-owner+w=401wt.eu-S1761401AbXHXMlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761401AbXHXMlI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 08:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758035AbXHXMk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 08:40:56 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:57252 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756850AbXHXMkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 08:40:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=kkTUGC3AJqHM7onoYynZy29QnXmiuuF4vjBBX+2DNuR3+OiNrfhG5ot3tPXBk5kJWK4MqcU6cCik5ALA/5RYxx2Bm3bgsLdXFsvkQHZ2hsWIjiH4/BUsH/DUe57K2aOBS57jwLBvyDBZIVcuVparsBAjc7C3LaGX0pQk9iExIIM=
Message-ID: <3ae72650708240540qcf05809j609e0fbb05f221b3@mail.gmail.com>
Date: Fri, 24 Aug 2007 14:40:54 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Meelis Roos" <mroos@linux.ee>
Subject: Re: isapnp & module autoload (udev?)
Cc: "Linux Kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.SOC.4.64.0708241434440.27738@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.SOC.4.64.0708241434440.27738@math.ut.ee>
X-Google-Sender-Auth: 1a3a19014dc8728e
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/24/07, Meelis Roos <mroos@linux.ee> wrote:
> I tested 2.6.23-rc3 along with Debian unstable on a older pentium2-era
> PC that has a ISA bus sound card that isapnp finds. snd-sb finds it too
> using isapnp. However, there seems to be no module autoloading
> happening.
>
> So, the question is: should isapnp moudle autoloading work with current
> kernel + current udev?

Not out-of-the-box, I guess. There are likely no aliases in the kernel
modules which match the hardware for these old drivers. You could put
them in a modprobe config file maybe.

What's in the module? What does:
  /sbin/modinfo <kernel module name> | grep alias
print?

And what does the hardware say? What does:
  grep . /sys/bus/pnp/devices/*/id
print?

Kay
