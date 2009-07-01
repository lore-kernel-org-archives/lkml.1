Return-Path: <linux-kernel-owner+w=401wt.eu-S1754181AbZGAKo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbZGAKo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 06:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbZGAKou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 06:44:50 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:38449 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbZGAKot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 06:44:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=W3GKOQXfHVDYcsaXKn7LF6WOYNSCpPac+wAyqAg3Sg2dhL5qkCAkEZaZGdj34hpRHq
         wBkY0Ruu0PiDOJ+r1/MBoQ+0hcKpKVuh17kFEFssv6cDEUpQoZ4i2NbuCXOx/DRUjTLU
         E3h08VwmTYjrlSwXz8DbrN2W4sXlL5JMAWzOo=
MIME-Version: 1.0
In-Reply-To: <20090630063437.GH1351@ucw.cz>
References: <6b1460640906250910x5ba98ce2wa990946486edfc0d@mail.gmail.com>
	 <20090630063437.GH1351@ucw.cz>
Date: Wed, 1 Jul 2009 12:44:52 +0200
Message-ID: <6b1460640907010344y5d73c5f4pbda88a54fd36095d@mail.gmail.com>
Subject: Re: [PATCH] trackpoint: enable selection of press-to-select button
From: Tom Weissmann <tom.weissmann@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: rubini@vision.unipv.it, linux-kernel@vger.kernel.org, jikos@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/30 Pavel Machek <pavel@ucw.cz>:

>> With this patch the trackpoint sysfs variable press-to-select can be
>> set not only to 0 (off), 1 (left button), but also to 2 (middle
>> button) and 3 (right button). This makes the feature more useful for
>> left-handed users with no visible changes to the right-handed default
>> behaviour.
>
> Uhuh. Ugly as night. Could we instead convert press to button 4, and
> let userland map it?

This would be much better.

However, as far as I know it is not possible to distinguish a "real"
button click from a PTS one.
The PTS button is determined by 3 masks (button 1, 2, 3). I believe
that if more than one mask is set, PTS will still only generate one
click, not two simultaneous ones.

Regards,
Tom
