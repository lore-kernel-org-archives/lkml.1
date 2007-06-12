Return-Path: <linux-kernel-owner+w=401wt.eu-S1756931AbXFLRBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931AbXFLRBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 13:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754541AbXFLRBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 13:01:11 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:16433 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278AbXFLRBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 13:01:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=fMZLLsZKRndySV1uM47gRpZTAjHnpJtJntX4hMZJKsOlR3zHlur4yeofI+2JOn+mKb/qcu892w9ypjdEmEMczVEzRVSE/cFFF7IQB0Tu/ZdOCUAxEy+RHFu1M1S4lGW1mH/oIhfHkQL22tg4CWU8AlEYcuB9jmxv1OMjxMe2zY4=
Message-ID: <6278d2220706121001r38a1752axba90de1b4e315f75@mail.gmail.com>
Date: Tue, 12 Jun 2007 18:01:08 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Jon Dufresne" <jon.dufresne@infinitevideocorporation.com>
Subject: Re: allocation failed: out of vmalloc space - use vmalloc=<size> to increase size.
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 Jun, 14:30, Jon Dufresne
<jon.dufresne@infinitevideocorporation.com> wrote:
> I am writing a linux kernel driver for a custom pci device. I am
> developing against the stock fedora 6 kernel on an x86. This device has
> 512 MB of IO memory reserved by BAR 3. Whenever I try to ioremap this
> space I get the error:
>
> allocation failed: out of vmalloc space - use vmalloc=<size> to increase
> size.
>
> I think I understand why this is happening. I obviously don't have
> enough vmalloc space to map such a large chunk of memory. I have been
> using Corbet's et el's "Linux Device Drivers", Love's "Linux Kernel
> Development", and many websites as a guide in this development process
> but have yet to come across information that will help me.
>
> I'm curious if there is a way around this issue. Or a better way of
> handling it so that I can properly map the entire io memory space.

You can boot with kernel parameter vmalloc=384M or so. I have
experienced problems with booting with other values, but YMMV.

Daniel

> Thanks for any help,
> Jon
-- 
Daniel J Blueman
