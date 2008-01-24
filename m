Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbYAXLTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbYAXLTg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 06:19:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbYAXLT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 06:19:29 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:56343 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbYAXLT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 06:19:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=XEZHclmJXf6xDotRf97IcDPa3V/XUz0fR90Y7tNeWJEp8goxwBa3tbhtvVGkyrIItMZg/xoYioMegn0msBardq59c3q6b8C49DN2DRuDDjs2WAXXqoS7JeZFfW9ucIozzds4tWU0easgfqIEKawplYoDOzNXqKl5Z4i+MpwICGk=
Message-ID: <84144f020801240319o1f51613fx6e823120f74a9cf9@mail.gmail.com>
Date: Thu, 24 Jan 2008 13:19:25 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Wilco Beekhuizen" <wilcobeekhuizen@gmail.com>
Subject: Re: [PATCH] Missing usb_find_device symbol from usb.c
Cc: "Greg KH" <greg@kroah.com>, linux-kernel@vger.kernel.org
In-Reply-To: <6c4c86470801240205u5361e090jc057270b03b5ebe7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6c4c86470801221118x530ee074qedb1da5eac1ca473@mail.gmail.com>
	 <20080124013720.GA21978@kroah.com>
	 <6c4c86470801240205u5361e090jc057270b03b5ebe7@mail.gmail.com>
X-Google-Sender-Auth: 6c55d44fe15c724c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wilco,

On Jan 24, 2008 12:05 PM, Wilco Beekhuizen <wilcobeekhuizen@gmail.com> wrote:
> Most code is pretty ancient, I just manage it so it compiles with
> recent kernels. Is there somehting exported that is similar to
> usb_find_device?

The problem is that iriverfs shouldn't be calling usb_find_device() at
all. What happens when you plug in two players to the same computer?
AFAICT the whole thing should be a proper USB driver in drivers/usb/
and not a "filesystem" in fs/.

                          Pekka
