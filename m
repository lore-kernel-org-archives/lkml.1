Return-Path: <linux-kernel-owner+w=401wt.eu-S1758204AbZA2Qit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204AbZA2Qit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 11:38:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbZA2Qik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 11:38:40 -0500
Received: from rv-out-0506.google.com ([209.85.198.231]:12266 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbZA2Qik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 11:38:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=J6aLSUBXJ3wNrOc5s0FAdCWeQvb5P/KTCM+bOnHjihs6+OnuT6FluVfJcLh9I3VVwq
         NB8mtbVMDiTBlaMQe3Dk0jhPvxpbsIi76Y5i65wYdnMUkPDX48yjoenbm6hZnxbnlfIw
         0bAIHnoOfB6UeQm5D0XPoHyfINKGNuYq9PnV4=
MIME-Version: 1.0
In-Reply-To: <20090129163442.13a9a3f7@lxorguk.ukuu.org.uk>
References: <1a26b4920901290302w5c9bb79cra29fda5e67cc96a4@mail.gmail.com>
	 <20090129134537.12121834@lxorguk.ukuu.org.uk>
	 <1a26b4920901290616r40c1edd0tec62d0e6bf24dc9@mail.gmail.com>
	 <20090129160602.235840c2@lxorguk.ukuu.org.uk>
	 <alpine.LRH.1.10.0901291722360.13097@twin.jikos.cz>
	 <20090129163442.13a9a3f7@lxorguk.ukuu.org.uk>
Date: Thu, 29 Jan 2009 17:38:38 +0100
Message-ID: <1a26b4920901290838u23a383b2x529f5c1e43211fa4@mail.gmail.com>
Subject: Re: NEWBIE: how to change serial device<->port association
From: Pazzo Da Legare <pazzodalegare@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Alan,

Thanks again. I think I will follow your last (easier) advice.

p

2009/1/29 Alan Cox <alan@lxorguk.ukuu.org.uk>:
> On Thu, 29 Jan 2009 17:22:54 +0100 (CET)
> Jiri Kosina <jkosina@suse.cz> wrote:
>
>> On Thu, 29 Jan 2009, Alan Cox wrote:
>>
>> > > The hws have a different combination of kind serials and I would like
>> > > to present the same ttyS* to applications. I need to have different
>> > By having multiple different kernels for the different systems ? That
>> > sounds like a really really complicated way to go about the problem when
>> > you could just add a config file to your application.
>>
>> Another possibility is udev rule.
>
> If its a simple naming choice then a symlink might do the job. What
> Fedora and several other distros do is to create symbolic links from
> "virtual" names like /dev/modem and /dev/cdrom to the relevant port using
> ln -s
>
