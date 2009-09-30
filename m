Return-Path: <linux-kernel-owner+w=401wt.eu-S1753605AbZI3AO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605AbZI3AO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 20:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbZI3AO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 20:14:56 -0400
Received: from mail-gx0-f212.google.com ([209.85.217.212]:51411 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbZI3AOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 20:14:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=nwPkltY0T4lybTET1AlDoP4y+GuUCgWwvz6w9cb0aqnub+YeG6zZMsCQMrUY/IqLGI
         pFot15MZbcR1KKI+KEIqFnITFxoXd4RMK2xJkYwrbNP4m/U8DOgt45gdfMRrfn9KK8kr
         DuDijRbE/Phy7KxWeDKwL3P+310QYDAKjgmL4=
Message-ID: <4AC2A300.1040001@gmail.com>
Date: Tue, 29 Sep 2009 18:14:56 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Chris M <chrisfu@hardc0re.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: VIA VT6330 PCI-E Combo Controller not fully supported
References: <4AC2604C.2060803@hardc0re.org.uk>
In-Reply-To: <4AC2604C.2060803@hardc0re.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2009 01:30 PM, Chris M wrote:
> Hi everyone!  I'll quickly introduce myself before I get to the crux of
> my reason for posting to the mailing list. My name is Chris Merrett and
> although I'm not a subscriber to the list (my mail server would likely
> cry), I check a well-known archive quite regularly just to try and keep
> on top of developments in the community.
>
> The reason I'm mailing is due to a partially-supported VIA chip present
> on a small handful of motherboards currently on sale. I mailed the
> maintainer (Jeff Garzik) to bring this to his attention quite some time
> ago, but I'd imagine he's not found the time to reply to me yet which is
> understandable. I figured that it'd be a good idea to make a post here
> with the info I've gathered, so that people affected by this same issue
> are aware that this particular chip isn't yet fully supported in the
> kernel.
>
> The VT6330 is a combo controller chip that handles both Firewire and
> PATA, and is present on my Asrock N7AD-SLI. I'm also aware of it being
> present on other Asrock boards, and presumably other boards from
> different manufacturers. The Firewire functionality is supported
> perfectly and without issue, but unfortunately the PATA support is
> lacking at the moment. VIA have some information on this at the
> following URL: http://www.via.com.tw/en/products/peripherals/1394/vt6330/
>
>  From the info on the URL above, it appears that the PATA functionality
> is identical to that of the VT6415 PATA controller, support for which
> was added in 2.6.28. The mailing list post made regarding the patch that
> was submitted can be found here:
> http://lkml.indiana.edu/hypermail/linux/kernel/0902.2/01428.html

If it is similar enough to the existing controllers then you may be able 
to just add the device ID into pata_via in a similar fashion..
