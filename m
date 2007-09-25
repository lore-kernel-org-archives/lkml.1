Return-Path: <linux-kernel-owner+w=401wt.eu-S1760693AbXIYS2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760693AbXIYS2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 14:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbXIYS2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 14:28:31 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:49032 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361AbXIYS2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 14:28:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=n8MMIka6Rs2oUEEg3dEIvMBpwgDWXtAFIYAOwa9IW1AFa8G0LKjb8d38YxDViLyJ3vuDIQZECRwC26iAJ1S8tHTmxOqVvbSfhRm0bs9OJV+UpnSlkG9igfQIcbrCECZ/iGXrd7hUEx7UhhDdrVhKXCxsBNI3eZWX1t24aFtkR0g=
Message-ID: <46F95346.7090601@gmail.com>
Date: Tue, 25 Sep 2007 12:28:22 -0600
From: "Berck E. Nash" <flyboy@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Jeff Garzik <jeff@garzik.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc7-mm1 AHCI ATA errors -- won't boot
References: <46F7FBCB.4030803@gmail.com> <46F8665A.4000206@garzik.org> <46F94FF3.1000400@gmail.com> <20070925182123.GC2367@kernel.dk>
In-Reply-To: <20070925182123.GC2367@kernel.dk>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Tue, Sep 25 2007, Berck E. Nash wrote:
>> Jeff Garzik wrote:
>>
>>> The first step would be to clone the "upstream" branch of
>>> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
>>>
>>> and see if the problem is reproducible there.  If yes, then you have
>>> narrowed down the problem to something my ATA devel tree has introduced
>>> into -mm.
>> Nope, you're off the hook.  The libata tree works great, so it must be
>> something else in -mm conflicting.

Whoops, sorry!  I just lied.  I'm a git newbie, and failed to actually
get the "upstream" branch the first time, so rc8 is clean, but it fails
when I actually pull the upstream branch.  I'll git bisect and get back
to you.

BErck
