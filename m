Return-Path: <linux-kernel-owner+w=401wt.eu-S1762389AbXGJQyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762389AbXGJQyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 12:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755140AbXGJQyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 12:54:39 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:5880 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272AbXGJQyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 12:54:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IkzFb6om6uNkmrW6R/hw+1L/ziCTa2O6pr3ISjPKYkIbNJIPrFsp6776h9caA3AtKf3R1+PGE/tnShwfeg0Ql0VxZbZowtjfz0XxlMgeFJ/Qjz3VkAeivkK5C1febuRhW7oNCZO8lrK1J3yRacEl06QR/H3PICNiOvJgS6CwnzQ=
Message-ID: <ec870ced0707100954h3472a9dbl4271b16859ee8fb8@mail.gmail.com>
Date: Tue, 10 Jul 2007 18:54:35 +0200
From: "Pawel Dziepak" <hryssta@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: utimes() with vfat is problematic
Cc: linux-fsdevel@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       hirofumi@mail.parknet.co.jp
In-Reply-To: <Pine.LNX.4.64.0707101836170.11053@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0707101142270.11053@fbirervta.pbzchgretzou.qr>
	 <ec870ced0707100318g87f22f8wcaa6a715c064338@mail.gmail.com>
	 <Pine.LNX.4.64.0707101836170.11053@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/10/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
> Linux does check for write permission, but _only_ for time=NULL.
> Hence it would be helpful if someone knows the exact SUS text,
> or whether this is not explicitly specified in SUS, leaving room
> for interpretation.
I have already checked it strictly. This "problem" occurs not only on
vfat partitions. You can *not* do uptime() for time!=NULL if you are
not a file owner. So, everything in Linux is correct.
It is not possible to solve your problem without changing SUS, it is
not even a problem...
I made mistake in my first post, because I was too implied by piece of
code that you've quoted.

Pawel
