Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbZCLSPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbZCLSPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 14:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752452AbZCLSPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 14:15:43 -0400
Received: from mail-qy0-f122.google.com ([209.85.221.122]:62759 "EHLO
	mail-qy0-f122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbZCLSPm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 14:15:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cc+ZfGBwuMAiNamQeNNh8hjTUhLG2l9mr8xck6BCHvYhW8tSwLWOQ8p9jBNUB67m8e
         3kJ+QbXNNkvwkE8girwc7M9gRPmO9jf/zTadMpdBb0h8Y57tSgrPLFDzRK2haDGxJPRv
         W3zfbjiA0OXzQ+LnBG0CHWvhCpkuF1p+CNtZM=
MIME-Version: 1.0
In-Reply-To: <49B8C12B.1040508@davidnewall.com>
References: <20090311200411.WPUP4619.eastrmmtao102.cox.net@eastrmimpo02.cox.net>
	 <20090311220700.GA16368@nostromo.devel.redhat.com>
	 <49B8C12B.1040508@davidnewall.com>
Date: Thu, 12 Mar 2009 14:15:39 -0400
Message-ID: <3aaafc130903121115j2f48d8a4h511dc8a7d9718de7@mail.gmail.com>
Subject: Re: [PATCH] /dev/time for Linux, inspired by Plan 9
From: "J.R. Mauro" <jrm8005@gmail.com>
To: David Newall <davidn@davidnewall.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 4:00 AM, David Newall <davidn@davidnewall.com> wrote:
> Bill Nottingham wrote:
>> Given the general array of current interfaces in the kernel, isn't
>> read/write of textual parameters better suited to sysfs or procfs
>> than a character device?
>
> Procfs and Sysfs are used to control devices.  Dev is used to access
> them.  Dev is the right place to fetch and set the time; having a text
> interface is beside the point.

I also think we're aiming for compatibility with Plan 9 here, which
keeps this file in /dev

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
