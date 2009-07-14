Return-Path: <linux-kernel-owner+w=401wt.eu-S1752085AbZGNAqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbZGNAqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 20:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751774AbZGNAqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 20:46:14 -0400
Received: from mail-yx0-f184.google.com ([209.85.210.184]:58960 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbZGNAqN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 20:46:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XFmZyyLm2bDO064C/WzrZJ92oW9QE1AmZiqE20iEhP6rwH+UtWq5o7Yj8xxkafkNiR
         7l0IzJ68+C1/Dc1imQaDBxFciRift/J3zMDhogfOq/W/WwMLhT0cni5P+sf4Yp8nDfEA
         cxKO4y5Y92jYwmtrYm5CcyZo9hMY5iSQWD9qk=
MIME-Version: 1.0
In-Reply-To: <20090713162559.GA1279@lilem.mirepesht>
References: <20090713151709.GA1297@lilem.mirepesht>
	 <20090713084058.547e88f0@infradead.org>
	 <20090713162559.GA1279@lilem.mirepesht>
Date: Tue, 14 Jul 2009 10:46:12 +1000
Message-ID: <21d7e9970907131746q4f1a34efw9d3e6efaa78aea34@mail.gmail.com>
Subject: Re: [PATCH 0/2] fbdev: add fillrect and copyarea ioctls
From: Dave Airlie <airlied@gmail.com>
To: Ali Gholami Rudi <ali@rudi.ir>
Cc: Arjan van de Ven <arjan@infradead.org>,
       fbdev <linux-fbdev-devel@lists.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Righi <righi.andrea@gmail.com>,
       Krzysztof Helt <krzysztof.h1@wp.pl>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Philippe De Muyter <phdm@macqel.be>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 2:25 AM, Ali Gholami Rudi<ali@rudi.ir> wrote:
> Arjan van de Ven <arjan@infradead.org> wrote:
>> On Mon, 13 Jul 2009 19:47:09 +0430
>> Ali Gholami Rudi <ali@rudi.ir> wrote:
>> > Is there any reason for not adding these ioctls to fbdev?  I searched
>> > the net and couldn't any.  Anyway, these patches simply implement
>> > those ioctls.
>> >
>>
>> can we turn this around, is there a reason to add them?
>> or in other words, how / where would these be used ?
>
> User-space programs that use framebuffer directly can use them.  I was
> writing a simple framebuffer virtual terminal (using libfreetype for
> fonts; like fbterm); scrolling and painting boxes would be faster if
> there was someway of using hardware accelerated operations.  I think
> other similar programs can benefit, too.

The general opinion is we should keep acceleration in userspace if at
all possible.

Not all hw can implement these usefully in the kernel, directfb
already does some
things for this.

Dave.
