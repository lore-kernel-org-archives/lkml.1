Return-Path: <linux-kernel-owner+w=401wt.eu-S1751707AbZI1Fwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707AbZI1Fwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 01:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbZI1Fw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 01:52:29 -0400
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1836 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbZI1Fw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 01:52:28 -0400
X-Greylist: delayed 814 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Sep 2009 01:52:28 EDT
Message-ID: <b452e0d0387e9350a5f8bb7fac242194.squirrel@webmail.xs4all.nl>
In-Reply-To: <20090926213528.GB23564@c.hsd1.tn.comcast.net>
References: <20090923005644.GA28244@c.hsd1.tn.comcast.net>
    <20090923213109.GA936@c.hsd1.tn.comcast.net>
    <4ABB9D6D.8000607@schaufler-ca.com>
    <20090925100630.GD10098@c.hsd1.tn.comcast.net>
    <4ABCEE71.6060703@schaufler-ca.com>
    <20090926213528.GB23564@c.hsd1.tn.comcast.net>
Date: Mon, 28 Sep 2009 07:38:55 +0200
Subject: Re: [RFC][PATCH] Privilege dropping security module
From: "Rob Meijer" <capibara@xs4all.nl>
To: "Andy Spencer" <andy753421@gmail.com>
Cc: "Casey Schaufler" <casey@schaufler-ca.com>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Reply-To: rmeijer@xs4all.nl
User-Agent: SquirrelMail/1.4.18
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, September 26, 2009 23:35, Andy Spencer wrote:
>> It's amazing who much of this stuff there is to attend to.  If you
>> haven't, run checkpatch.py on your patches. You'll need to pass that
>> eventually.
>
> I've fixed the remaining things that checkpatch.pl suggests as well as a
> few others and will include those checks for future patches.
>
>
>> Hmm. You are working with the Linux DAC mechanism, even if only within
>> a process tree. You're not dropping privilege, you're applying a mask
>> to the file permission bits, currently for file system objects, and
>> with other objects (sysvipc at least) in the future. Hmm. modemask?
>> Something derived from "restricted process tree?"
>
> `Access Control Masking' or `Policy Masking' perhaps?
>

Or  'Permission Attenuation' ?

