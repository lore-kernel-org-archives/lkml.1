Return-Path: <linux-kernel-owner+w=401wt.eu-S1754944AbXGBK6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbXGBK6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 06:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbXGBK6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 06:58:11 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:6443 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbXGBK6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 06:58:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=I8z+D4KKOX/EPCRjkyp3sNVXfaz0k+1N8z96T0QMslU3138IHnF+UFFuc+FLpc0l5SKdorSg9XE5cqckcRE8h3F0L8RhtdUkYYBCeuXGhqnLTHUxHmzIH744d/SayE2GxSiQxFlEkZorq8UPwTtTf2NMe0DVARGCfaW4Jwp3owQ=
Message-ID: <4688D9F2.6020000@gmail.com>
Date: Mon, 02 Jul 2007 19:56:50 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: David Greaves <david@dgreaves.com>
CC: David Chinner <dgc@sgi.com>, David Robinson <zxvdr.au@gmail.com>,
       LVM general discussion and development 
	<linux-lvm@redhat.com>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com, linux-pm <linux-pm@lists.osdl.org>,
       LinuxRaid <linux-raid@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [linux-lvm] 2.6.22-rc5 XFS fails after hibernate/resume
References: <46744065.6060605@dgreaves.com> <4674645F.5000906@gmail.com> <46751D37.5020608@dgreaves.com> <4676390E.6010202@dgreaves.com> <20070618145007.GE85884050@sgi.com> <4676D97E.4000403@dgreaves.com> <4677A0C7.4000306@dgreaves.com> <4677A596.7090404@gmail.com> <4677E496.3080506@dgreaves.com> <4678DF56.1020903@gmail.com> <467ABE25.7060303@dgreaves.com> <4684C0DD.4080702@dgreaves.com>
In-Reply-To: <4684C0DD.4080702@dgreaves.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Greaves wrote:
>> Tejun Heo wrote:
>>> It's really weird tho.  The PHY RDY status changed events are coming
>>> from the device which is NOT used while resuming
> 
> There is an obvious problem there though Tejun (the errors even when sda
> isn't involved in the OS boot) - can I start another thread about that
> issue/bug later? I need to reshuffle partitions so I'd rather get the
> hibernate working first and then go back to it if that's OK?

Yeah, sure.  The problem is that we don't know whether or how those two
are related.  It would be great if there's a way to verify memory image
read from hibernation is intact.  Rafael, any ideas?

Thanks.

-- 
tejun
