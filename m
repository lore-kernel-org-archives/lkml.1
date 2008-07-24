Return-Path: <linux-kernel-owner+w=401wt.eu-S1754182AbYGXOIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbYGXOIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 10:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbYGXOIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 10:08:12 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:62911 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbYGXOIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 10:08:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=AlOc6PkuHKmrzhraG1GM4TFsvIHf39/PFGwHdzVkmO1Pgdrzt8R+eKFqhRotxsthEa
         32RFqedAyu7tN7kW3VrgkiOVvvvHyJnPajUlUaVbu+RRs67Q+N0JTUba0Lyjcu36zZja
         62h/r/evzgy1CjXzUDxCOzXuz1tkevG3EWpYE=
Message-ID: <38b2ab8a0807240708j7d6782b7te6123fdd7416ec95@mail.gmail.com>
Date: Thu, 24 Jul 2008 16:08:10 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: KGDB fails to pass selft tests on x86-64 (v2.6.26)
In-Reply-To: <38b2ab8a0807240624v7ec90c50n8105f830d10dddd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0807240624v7ec90c50n8105f830d10dddd@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 3:24 PM, Francis Moreau <francis.moro@gmail.com> wrote:
> I wanted to give kgdb a try on a v2.6.26 kernel. My cpu is an
> x86-64.
>
> So the first thing I did is to enable kgdb support and also the
> kgdb self tests:
>
> CONFIG_HAVE_ARCH_KGDB=y
> CONFIG_KGDB=y
> CONFIG_KGDB_SERIAL_CONSOLE=y
> CONFIG_KGDB_TESTS=y
> # CONFIG_KGDB_TESTS_ON_BOOT is not set
>
> Once compiled I booted this kernel through qemu and got the following:
>

and unfortunately it seems this issue is related to qemu: if I did boot the
kernel without qemu and the self tests passed...


-- 
Francis
