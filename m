Return-Path: <linux-kernel-owner+w=401wt.eu-S1754490AbYKXQ7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbYKXQ7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 11:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbYKXQ7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 11:59:00 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:34536 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052AbYKXQ67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 11:58:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MwZFT3NgU08eisKfo/pB8hCqY3oBjWBNw/yShm1iSwSau/ykeVKtg8X3biU7QzxoLo
         l0slD7IavAKZkwWz9dh/npmYzWBJ24o+/iov0Nq8rmCZQfGCe8j/jtKjWiCvIW2z4y/O
         pgXBd+w+6IVpIxgMSl0uqeGRi7ib1Ik7VmPVU=
Message-ID: <71cd59b00811240858p3b830c73qc2742023d2977054@mail.gmail.com>
Date: Mon, 24 Nov 2008 17:58:57 +0100
From: "Corentin Chary" <corentin.chary@gmail.com>
To: "Tom Hughes" <tom@compton.nu>
Subject: Re: [Acpi4asus-user] [PATCH 1/1] cpufreq: eeepc 900 frequency scaling driver
Cc: "Thomas Renninger" <trenn@suse.de>, acpi4asus-user@lists.sourceforge.net,
       "Dave Jones" <davej@redhat.com>,
       "Cristiano Prisciandaro" <cristiano.p@solnet.ch>,
       linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
In-Reply-To: <492ADACC.6030807@compton.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1227454026.7262.59.camel@localhost> <492A7632.4040106@compton.nu>
	 <200811241613.25557.trenn@suse.de> <200811241736.53067.trenn@suse.de>
	 <71cd59b00811240841j69451aafje5cbb5204dbff2e5@mail.gmail.com>
	 <492ADACC.6030807@compton.nu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2008 at 5:48 PM, Tom Hughes <tom@compton.nu> wrote:
> Corentin Chary wrote:
>
>> Why not just modprobe p4-clockmod ?
>> It already has all we want and works perfectly well.
>
> My understanding is p4-clockmod doesn't really change anything at all and
> doesn't gain you any real benefit. I know lots of web pages tell you to use
> it on the eee but everything I've read says that is nonsense.

Just modprobe p4-clockmod
- use cpufreq to go to the lower frequency
- run something cpu intensive
- go to the higher frequency (900mghz)
- you'll see the difference

at least, it works with my eeepc 700, maybe 900 is different for that,
but it seems unlikely to me.
