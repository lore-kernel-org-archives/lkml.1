Return-Path: <linux-kernel-owner+w=401wt.eu-S1756099AbYKCOoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbYKCOoa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 09:44:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754371AbYKCOoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 09:44:21 -0500
Received: from ik-out-1112.google.com ([66.249.90.183]:38945 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522AbYKCOoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 09:44:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=LgVaXrEyyhBtlMiLRGKOuT0PJd2Ubr7GrrpqdLaGqziU2mMokoafp6j/513ej+PceU
         hMP+NJf/OvkQn6RF0B062zJnPlpZp0qx0n4j0fIiSug0IIDy1fYbt8q0nslcOHw9ZXs4
         djCk97ZlUBfW2ydyO/494B/9V+yHl+x/2IqbU=
Message-ID: <490F0E3E.80002@gmail.com>
Date: Mon, 03 Nov 2008 15:44:14 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Nobin Mathew <nobin.mathew@gmail.com>
CC: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: sharing interrupt between PCI device
References: <8d6898730811030532nf4db16fv99b7b8cc722bda0b@mail.gmail.com>
In-Reply-To: <8d6898730811030532nf4db16fv99b7b8cc722bda0b@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2008 02:32 PM, Nobin Mathew wrote:
> Hi,
> 
> I think this question is already asked in this mailing list and Sorry
> for asking this again.
> 
> My problem is this:
> 
> I have two PCI devices ( also two kernel drivers for those) which
> shares the interupt. When I remove one driver other device stops
> working, which is happening due to pci_disable_device () in removed
> driver. This call is disabling the shared interrupt.
> 
> We can avoid this by just removing the pci_disable_device () in the
> driver, but i dont think this is a good way (correct me if I am
> wrong).
> 
> Can you suggest some ways to overcome this issue.

-ENOCODE

Without seeing the code, we can't help you much.
