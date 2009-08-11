Return-Path: <linux-kernel-owner+w=401wt.eu-S1753536AbZHKMQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbZHKMQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbZHKMQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:16:55 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:59359 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbZHKMQv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:16:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=XsW9N7UNDb13pU1V5opSCQS/rieh84EFd69Z5KbzKrUwDleCIZv3JG+/5fXkcJPPwe
         m1E/rIwQbgtn834TkghdPY6XzOgd2K+MgsNnR+d1VgqBcWsU+fLzBCwybCIYQixXmRZ3
         4UwTerT5mOrvMFtiElmjeYFRjCGzGDndQmIdU=
MIME-Version: 1.0
In-Reply-To: <20090811000112.GB13314@kroah.com>
References: <20090810193653.f228cf06.sfr@canb.auug.org.au> 
	<1249921736508-git-send-email-LW@KARO-electronics.de> <20090811000112.GB13314@kroah.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 11 Aug 2009 03:59:43 -0400
Message-ID: <8bd0f97a0908110059y344071adn3656eaea3d7edddf@mail.gmail.com>
Subject: Re: [PATCH] Fix compiler warnings and remove debug messages
To: Greg KH <greg@kroah.com>
Cc: Lothar Wassmann <LW@karo-electronics.de>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>, Lothar Wassmann <lothar@ipc1.ka-ro>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 20:01, Greg KH wrote:
> On Mon, Aug 10, 2009 at 06:28:56PM +0200, Lothar Wassmann wrote:
>> This patch fixes the reported compiler warnings and removes excessive debug messages.
>> Compile tested only!
>
> I'd prefer the correct fixes for this driver.  Mike, any thoughts on
> some fixes for this?

if it's simply fixing printf modifiers, then i can send out a patch for that.

the changelog simply states "the reported compiler warnings" ... what
exactly must i do to reproduce these ?
-mike
