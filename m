Return-Path: <linux-kernel-owner+w=401wt.eu-S1759482AbYFLLEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759482AbYFLLEP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 07:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756625AbYFLLD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 07:03:59 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:38179 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601AbYFLLD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 07:03:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=L0FNSevRD1z9p4c/IWKX6FEG8Rkipv7vQaiZvhB/TqeUDRHJg3Ft7UkUzUqcKw7U9Q
         SH1QT9MXD6L1t1ygrUZCS3s1L183Xdqy0e7EXFi7uOQtQAJ8pY04Lv3O1nfXD3dhSieT
         IgMSkepfv4flOMTnwWu2Cy9UgTy0K8u3/0Zu8=
Message-ID: <5a4c581d0806120403n410b8deam627f4623d9b22a71@mail.gmail.com>
Date: Thu, 12 Jun 2008 13:03:56 +0200
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: "Elijah Anderson" <kd0bpv@gmail.com>
Subject: Re: 8139cp/too support not accessible?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4850C9F5.8000104@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4850C9F5.8000104@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 9:02 AM, Elijah Anderson <kd0bpv@gmail.com> wrote:
> Hey List,
>
> I will admit right off the bat that I'm new to interacting directly with the
> kernel, much less building one.
>
> The issue I'm having is that my ethernet card requires either the 8139cp or
> 8139too module. I don't remember which one, so I want to modularize them
> both. Problem is, using $make xconfig; I can't select it. I have the
> interface set to show me all the options, but the modules I need are grayed
> out and I can't change the value.
>
> Using $make config; It doesn't show them, even if I say Y to "Prompt for
> development and/or incomplete code/drivers"
>
> Is there a way to manually select those drivers for modularization, or am I
> just missing a step somewhere?
>
> Thank you.

That's not really a kernel issue... however, since I have
 that configuration (both drivers modular) at home, I
 know it works :)

You probably haven't selected NET_PCI, which is the
    entry described by

 "EISA, VLB, PCI and on board controllers"

The drivers you want depend on the above entry being selected.

--alessandro

 "Give me love / Or give me hate
 Give me anything that's not just ok"

 (Sophia, 'Weightless')
