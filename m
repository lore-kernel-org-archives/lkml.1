Return-Path: <linux-kernel-owner+w=401wt.eu-S1753988AbZFFJRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbZFFJRV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 05:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbZFFJRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 05:17:14 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:61155 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbZFFJRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 05:17:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qHwNsM6Z3epCTCqwzTD+J4Dah5Cc/dL39vF4a3NMvHbcubqbSyKLgXA1xa+FHWq2A3
         YzA6/QhDunQwA16lnvMsDhPQzRf3otMlYH3az3Cx4rJeTRHCdwpIbOYJ375CMu00ieTO
         puWKMECukdXvVAKNHfIyjvJ3fsX+kmuscU8Fc=
MIME-Version: 1.0
In-Reply-To: <71cd59b00906060052n153835e8p37e0ccb7c73ba5c5@mail.gmail.com>
References: <Pine.LNX.4.64.0906051157460.22218@melkki.cs.Helsinki.FI>
	 <20090605130835.e21eaf37.akpm@linux-foundation.org>
	 <71cd59b00906060025w66d770f7he34f9172cd720c8c@mail.gmail.com>
	 <20090606003159.114c2fab.akpm@linux-foundation.org>
	 <71cd59b00906060052n153835e8p37e0ccb7c73ba5c5@mail.gmail.com>
Date: Sat, 6 Jun 2009 12:17:14 +0300
X-Google-Sender-Auth: c27704e19d2cc58a
Message-ID: <84144f020906060217r2ac950dcp74f4c66d64a292a3@mail.gmail.com>
Subject: Re: [PATCH] eeepc-laptop: enable camera by default
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       acpi4asus-user@lists.sourceforge.net, len.brown@intel.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Corentin,

On Sat, 6 Jun 2009 09:25:34 +0200 Corentin Chary
<corentin.chary@gmail.com> wrote:
>>> fixed patch pushed into acpi4asus.

On Sat, Jun 6, 2009 at 9:31 AM, Andrew Morton<akpm@linux-foundation.org> wrote:
>> What's that?
>>
>> Should it be added to linux-next?

On Sat, Jun 6, 2009 at 10:52 AM, Corentin Chary
<corentin.chary@gmail.com> wrote:
> http://acpi4asus.sourceforge.net/ -
> http://git.iksaif.net/?p=acpi4asus.git;a=summary
> The tree is based on
> git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6
>
> It's where I regroup eeepc/asus patchs before sending them to Len.
>
> I don't think it should be added to linux-next, because the patchs
> will first go into the acpi tree, wich is in linux-next.

I guess the main question is how often does Len pull from your tree?
If the delay is longer than few days, it might make sense to put your
tree directly into linux-next for early integration. And as long as
you don't rebase the "for-next" branch and keep it append-only, there
isn't going to be any conflicts either when Len pulls your tree and
publishes the result in linux-next.

                                Pekka
