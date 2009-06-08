Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbZFHG7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbZFHG7B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 02:59:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751639AbZFHG6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 02:58:53 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:3147 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbZFHG6x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 02:58:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hdEvBp1M0OqnKU1bXZF2WG0isINbESrnIlRWJMcgoMyqSCK116ERX6AFt5pCkkX0wh
         zV12TDAu1fLF0Xoyg3m3FH8TR/vMwmki83ubTD0XsStmj8tfcWuYiSOyHOd70Pd9EMZs
         odi+Zcnljdlz2nJklOSG/a9E1atuawvz/nQMU=
MIME-Version: 1.0
In-Reply-To: <20090607152152.GA7785@n2100.arm.linux.org.uk>
References: <20090605131625.GC1376@ucw.cz>
	 <20090607152152.GA7785@n2100.arm.linux.org.uk>
Date: Mon, 8 Jun 2009 14:58:54 +0800
Message-ID: <f17812d70906072358i69b4ce09oeb6cd455277b050f@mail.gmail.com>
Subject: Re: zaurus needs generic pxa suspend/resume routines
From: Eric Miao <eric.y.miao@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Pavel Machek <pavel@ucw.cz>, rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com, omegamoon@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 7, 2009 at 11:21 PM, Russell King - ARM
Linux<linux@arm.linux.org.uk> wrote:
> On Fri, Jun 05, 2009 at 03:16:25PM +0200, Pavel Machek wrote:
>> For suspend/resume to work, spitz needs pxa_pm_suspend/resume to be
>> called. Otherwise PSPR is not set properly, and system will die during
>> resume.
>
> 100 points for copying lots of people.  0 points for omitting the right
> person.  Add Eric.
>
> Eric, ack?
>

Yes, I think this is the best trade-off for the moment.

Acked-by: Eric Miao <eric.miao@marvell.com>

And Russell you may want to queue this for this -rc phase, looks
it's still -rc8-git5.
