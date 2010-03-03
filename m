Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab0CCUVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 15:21:55 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:39429 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860Ab0CCUVs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 15:21:48 -0500
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/62] Driver-Core: devtmpfs - remove EXPERIMENTAL and  enable it by default
References: <20100302230933.GA32287@kroah.com>
	<1267572541-410-19-git-send-email-gregkh@suse.de>
	<m1635eow8a.fsf@fess.ebiederm.org>
	<alpine.LFD.2.00.1003030839550.3627@localhost.localdomain>
	<ac3eb2511003031203t2b30bbbjcb9a05e9851667ea@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 03 Mar 2010 12:21:44 -0800
In-Reply-To: <ac3eb2511003031203t2b30bbbjcb9a05e9851667ea@mail.gmail.com> (Kay Sievers's message of "Wed\, 3 Mar 2010 10\:03\:19 -1000")
Message-ID: <m1y6i9i2av.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers <kay.sievers@vrfy.org> writes:

> On Wed, Mar 3, 2010 at 06:46, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> Greg, please shut down people like Kay that want to enable something by
>> default. We want a _minimal_  working config, not a maximal. If somebody
>> has a distro that needs this, they can enable it _then_. Not "let's try to
>> make people enable it whether they need it or not, because they _might_".
>>
>> Because "might need it" is simply not good enough. A "must have" is the
>> only reason to do 'default y'.
>
> No problem, if that's he rule, then let's drop the "y".  I always
> understood the defaults as the "usually needed to bring up a box"
> setting. We had this discussion already with Arjan who stated the same
> as you, but we kid of missed to take action on that, sorry.
>
> For the "must have", we will not be able to bootup the upcoming Ubuntu
> and openSUSE development distros without it, not sure about Fedora,
> the support is there, but it might still work without it. Some smaller
> distros also already depend on it.

Is this a case of the initial ramdisks won't work, or have you removed
support from udev to create device nodes?

Eric
