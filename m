Return-Path: <linux-kernel-owner+w=401wt.eu-S1756188AbYJWLLF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188AbYJWLLF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 07:11:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753652AbYJWLKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 07:10:52 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:64681 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbYJWLKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 07:10:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gOBZh+UHs6HfxfVhjGV2to7dpo3XAO+gc15kJICEpFt7v2mgzO7CekHcR0Lu6rab/w
         rAkuzygyJjLQD7aEzpFu8J5hgPBp4cT8hMuwr+6OsyMzX3gypYzMp052/Z0AHBw3UIs2
         faFt4QjLNZOL8a/jWGk3yqLcJ7J/6HOV4Q1GU=
Message-ID: <d9def9db0810230410w9508d2cjf91b44156a624a4f@mail.gmail.com>
Date: Thu, 23 Oct 2008 07:10:46 -0400
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/7] Adding empia base driver
Cc: "Greg KH" <greg@kroah.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       em28xx <em28xx@mcentral.de>, acano@fastmail.fm,
       "Andre Kelmanson" <akelmanson@gmail.com>,
       "Bouwsma Barry" <freebeer.bouwsma@gmail.com>,
       "Dan Kreiser" <kreiser@informatik.hu-berlin.de>,
       "Frank Neuber" <fn@kernelport.de>,
       "Jelle de Jong" <jelledejong@powercraft.nl>,
       "John Stowers" <john.stowers.lists@gmail.com>,
       "Lukas Kuna" <lukas.kuna@evkanet.net>,
       "Stefan Vonolfen" <stefan.vonolfen@gmail.com>,
       "Stephan Berberig" <s.berberig@arcor.de>,
       "Thomas Giesecke" <thomas.giesecke@ibgmbh-naumburg.de>,
       "Vitaly Wool" <vwool@ru.mvista.com>, "Zhenyu Wang" <zhen78@gmail.com>
In-Reply-To: <20081023102901.59c14cf6@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9def9db0810221414w5348acf3re31a033ea7179462@mail.gmail.com>
	 <20081022220903.GA15278@kroah.com>
	 <20081023102901.59c14cf6@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 5:29 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> This is going to cause a big problem for distros as they will not know
>> which to enable, so they will probably just disable this one, which is
>> what I don't think you want to have happen :(
>
> Before looking into any of this talk to the V4L and DVB maintainers,
> browse video4linux list and have a happy read of stuff like:
>
> http://thread.gmane.org/gmane.linux.drivers.dvb/35454
>

There's a much much longer history about that, this can safely be ignored.
The history goes back 3 years .. this one only goes back a couple of months.
It will take at least a week for a single person to understand the
whole issue from the beginning on, although I'd say it's not relevant.

In case of Userspace tuners, see cx88 freeBSD driver the project is
growing, netBSD
is also using parts of that em28xx driver - there was no complaint at
all about it.
Some people don't like that idea in linux so it's ok and it has been
redone, no big deal anymore.

Markus

>
> Now I wonder why Markus didn't cc Mauro on this despite Mauro being
> maintainer.
>
> Alan
>
