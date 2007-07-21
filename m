Return-Path: <linux-kernel-owner+w=401wt.eu-S935751AbXGUWNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935751AbXGUWNj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 18:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935208AbXGUWMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 18:12:19 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:22757 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934963AbXGUWMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 18:12:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YP6Y5R97dGpB37ne2ZPP3j+V9wEvIyZK8ykKJh97MWrF62yT5rfrOsbweWYF33en+LD/g0qM2BxEf1ZDQufB8L7EZyryKmav6GTEgWdWxW9YVyGXiQeEt6RCUTH6p/vbhuj+BnW2FCngb6nzLYizLtSgAO1YRdTby4fAamAK4k0=
Message-ID: <8bd0f97a0707211512t46db7eedid21c759613d06a75@mail.gmail.com>
Date: Sat, 21 Jul 2007 18:12:15 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [kbuild-devel] [PATCH 25/33] kbuild: use POSIX BRE in headers install target
Cc: "Oleg Verych" <olecom@flower.upol.cz>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20070721221142.GB2912@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11846813442810-git-send-email-sam@ravnborg.org>
	 <11846813441741-git-send-email-sam@ravnborg.org>
	 <1184681344376-git-send-email-sam@ravnborg.org>
	 <E1ICAEU-0005an-5F@flower>
	 <8bd0f97a0707210127m565f9b2cnc7a8a203f671e948@mail.gmail.com>
	 <20070721100422.GK475@flower.upol.cz>
	 <8bd0f97a0707211221l2c7fedeoea8612876350db6d@mail.gmail.com>
	 <20070721203916.GA2912@uranus.ravnborg.org>
	 <8bd0f97a0707211503y3de01d30n9b283237103fbc4@mail.gmail.com>
	 <20070721221142.GB2912@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/21/07, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Sat, Jul 21, 2007 at 06:03:00PM -0400, Mike Frysinger wrote:
> > On 7/21/07, Sam Ravnborg <sam@ravnborg.org> wrote:
> > >I would much more prefer this functionality to be integrated into unifdef.
> > >There is no good reason to have two different preprocesisng methonds, one
> > >being the sed based one and the other the unidef one.
> > >
> > >A sinlge dedicated program that contian the sum of the functionality would
> > >be faster too.
> >
> > which functionality ?  normalizing of whitespace or all these
> > linux-specific hacks ?  unifdef serves one specific function which is
> > stated in its manpage: remove preprocessor conditionals from code.
>
> At present the kernel has a private copy of unidef. So adjusting the
> private copy for the needs of the kernels seems like a god plan.

didnt realize the kernel had integrated it since it didnt at first ...
so yeah, extending it however we see fit should be fine
-mike
