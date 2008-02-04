Return-Path: <linux-kernel-owner+w=401wt.eu-S1756739AbYBDWgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbYBDWgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 17:36:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755367AbYBDWge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 17:36:34 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:13794 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670AbYBDWgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 17:36:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=pcAcR/rIgwQQnszupuBlUsd9Et7Q5fuxn+W5GrOs9YdvyNXRd2zph9RQEGC1XPAWIYes3tt/gTk9nKgBIax5TyjzPFNK3WurYMmnuoTy2sisbrjiyZevWyo1dDj2QWm578ezpFxSKrz/lDZetpuyawLaocCmJFKZnnlGzEq4afA=
Message-ID: <47A7936C.9090103@gmail.com>
Date: Mon, 04 Feb 2008 23:36:28 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: Oliver Pinter <oliver.pntr@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Bruno Randolf <bruno@thinktube.com>, netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       ath5k-devel@lists.ath5k.org
Subject: Re: [Wireless, ath5k] 2.6.24-git13 9135f1901ee6449dfe338adf6e40e9c2025b8150
References: <6101e8c40802040600q804e40cs97d0031920e58d9d@mail.gmail.com>	 <47A774AB.5060008@gmail.com>	 <6101e8c40802041334o20b2b391la5b0a5f557ee67c5@mail.gmail.com> <1202161934.24527.5.camel@localhost.localdomain>
In-Reply-To: <1202161934.24527.5.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2008 10:52 PM, Dan Williams wrote:
> On Mon, 2008-02-04 at 22:34 +0100, Oliver Pinter wrote:
>> On 2/4/08, Jiri Slaby <jirislaby@gmail.com> wrote:
>>> On 02/04/2008 03:00 PM, Oliver Pinter (Pintér Olivér) wrote:
>>>> ioctl[SIOCSIWAUTH]: Operation not supported
>>>> WEXT auth param 4 value 0x0 - bind(PF_UNIX): Address already in use
>>> 4 - 0x0 is TKIP, nothing we should worry about.
>>>
>>>> ctrl_iface exists and seems to be in use - cannot override it
>>>> Delete '/var/run/wpa_supplicant/ath0' manually if it is not used anymore
>>>> Failed to initialize control interface '/var/run/wpa_supplicant'.
>>>> You may have another wpa_supplicant process already running or the file
>>> was
>>>> left by an unclean termination of wpa_supplicant in which case you will
>>> need
>>>> to manually remove this file before starting wpa_supplicant again.
>>> Have you?
>> yes

Ok, on one log it can't be bound and connected to, on the others it can be 
bound. I think you have 2 wpa/NM/whatever processes there which try to assign.

> Note that the specific behavior of the process requesting scan results
> can sometimes interact badly with the driver.  The driver most likely
> needs to cope with this (by caching the BSS list internally for example)
> and handle whatever behavior userspace programs throw at it.

The driver doesn't cope with scanning at all. It doesn't support passive scans. 
It's a mac layer who scans (sends probe request for each channel and listens for 
probe response for a while) here.

The scan results as Dan mentioned will be appreciated.
