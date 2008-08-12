Return-Path: <linux-kernel-owner+w=401wt.eu-S1753628AbYHLOOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbYHLOOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 10:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752337AbYHLOOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 10:14:25 -0400
Received: from hs-out-0708.google.com ([64.233.178.250]:55768 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbYHLOOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 10:14:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=W5oal1Fw7cug+axAF/is7iXZpVO3P1pOeJTEFHvKDPluLioMXqoRRvJUuihdFVs6mz
         Ofx7zdhhxtQGyul8z2DJfho6tEe9a+VHYcYnQedGlEqdj+zxN5V2vxT5wO0hbibrCBaS
         HzmZ0qYa5hbp0zYj8nsNnOkFvXvejHBVqYkE8=
Message-ID: <e8ca35370808120714x42e37db8sb76ad098edb398db@mail.gmail.com>
Date: Tue, 12 Aug 2008 16:14:22 +0200
From: "Pascal Terjan" <pterjan@mandriva.com>
To: "Shaohua Li" <shaohua.li@intel.com>
Subject: Re: 2.6.26 fails to boot on Acer TravelMate 5520 due to PCIE ASPM
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@vger.kernel.org>
In-Reply-To: <1216400987.21525.9.camel@plop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1216286420.26653.12.camel@plop>
	 <1216344100.6105.1.camel@sli10-desk.sh.intel.com>
	 <1216400987.21525.9.camel@plop>
X-Google-Sender-Auth: fd61a0b8fc4aac64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 7:09 PM, Pascal Terjan <pterjan@mandriva.com> wrote:
> On Fri, 2008-07-18 at 09:21 +0800, Shaohua Li wrote:
>> On Thu, 2008-07-17 at 11:20 +0200, Pascal Terjan wrote:
>> > When CONFIG_PCIEASPM is activated, Acer TravelMate 5520 will hang at
>> > "Setting up standard PCI resources"
>> >
>> > pcie_noaspm does not seem to help
>> Can you double check it? With pcie_noaspm, the aspm driver does nothing.
>>
>
> Indeed, the option actually works fine and allows the machine to boot my
> small test kernel with CONFIG_PCIEASPM.
>
> I had tried the option on another 2.6.26 vanilla kernel (with a totally
> different config) and that one hangs at the same point without ASPM so
> I'm currently doing some more investigation

OK, I could work on this machine again and have some news.

I had another bug on 2.6.26 causing hang at almost the same place and
fixed by a0176e2485ce6468f9b74264a2fd6c19811f027a.

I can confirm that pcie_noaspm is now enough to boot on this machine
and will try to
identify the faulty device
