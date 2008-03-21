Return-Path: <linux-kernel-owner+w=401wt.eu-S1756632AbYCUOok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632AbYCUOok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 10:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbYCUOoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 10:44:32 -0400
Received: from ag-out-0708.google.com ([72.14.246.247]:6948 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbYCUOob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 10:44:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=uL7IUYYHQUFNNJn1Zh8QbSAeNqw4its1PtaWAH4G4SL3qOCakfbq+N6ZqYdSSvO+CAtS25eHAXG2dbwKnuDlA/FBQqIAWTqmzenNSdCRsfjfc5vbw/9q2J6vLMwMpa9rOaiRL+3fAePLOC3dYsb6DVjHiptbqJpYBDfTK/UYVjo=
Date: Fri, 21 Mar 2008 09:44:16 -0500
From: Josh Boyer <jwboyer@gmail.com>
To: "Sreen Tallam" <tallam.sreen@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Device tree file customization for 2.6.18
Message-ID: <20080321094416.58f827ba@hansolo.jdub.homelinux.org>
In-Reply-To: <5b1d25eb0803201000s7b60143fl61afd832140c2ac4@mail.gmail.com>
References: <5b1d25eb0803201000s7b60143fl61afd832140c2ac4@mail.gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2008 10:00:54 -0700
"Sreen Tallam" <tallam.sreen@gmail.com> wrote:

> Hi All,
> 
> I have been using 2.6.10 until now and moving over 2.6.18.
> And I trying to build a 2.6.18 kernel for a PowerPC 405GP.

2.6.18 is fairly old at this point.

> I discovered that there is a .dts file needed by the kernel.
> I have no idea how to customize this file. Any tips, suggestions or
> Documentation that I can look at?

There's Documentation/powerpc/booting-without-of.txt.  Though if you're
going to use 2.6.18, I'd suggest sticking with arch/ppc instead of
arch/powerpc.  The former doesn't require the device tree.

> I am using u-boot as my board's FW.
> Also, I have a Walnut like board for which I am building the kernel.

Walnut has a dts in the kernel already.  You should be able to derive
from that fairly easily.  If you really want to use an arch/powerpc
based kernel I suggest using 2.6.24 as your starting point.

josh
