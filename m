Return-Path: <linux-kernel-owner+w=401wt.eu-S932192AbXH1VYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192AbXH1VYA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 17:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbXH1VXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 17:23:51 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:25089 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871AbXH1VXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 17:23:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rsg1I7zFO+JIqyGGMPJjV+agIJO/RxUMNoJz7SL8o0q5nMP9Q0BlbqT/nCUCGv0w1FVTkzWS1L3CsVUCrJvegZRxFD9sSwHQnN1KtpHpZhgxgxQN5UMrz06/F1eUo/qWxcZys/sCfctFlcqcfxqtfbZDbtEY9CJB0XT7IcO1Us8=
Message-ID: <a4e6962a0708281356p2c808841ud486376974c94eff@mail.gmail.com>
Date: Tue, 28 Aug 2007 15:56:43 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Subject: Re: [kvm-devel] [RFC] 9p: add KVM/QEMU pci transport
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       v9fs-developer@lists.sourceforge.net, lguest@ozlabs.org
In-Reply-To: <200708282208.52902.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11883271601857-git-send-email-ericvh@gmail.com>
	 <11883271601227-git-send-email-ericvh@gmail.com>
	 <11883271602233-git-send-email-ericvh@gmail.com>
	 <200708282208.52902.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/28/07, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 28 August 2007, Eric Van Hensbergen wrote:
>
> > This adds a shared memory transport for a synthetic 9p device for
> > paravirtualized file system support under KVM/QEMU.
>
> Nice driver. I'm hoping we can do a virtio driver using a similar
> concept.
>

Yes.  I'm looking at the patches from Dor now, it should be pretty
straight forward.  The PCI is interesting in its own right for other
(non-virtual) projects we've been playing with....

     -eric
