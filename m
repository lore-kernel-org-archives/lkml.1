Return-Path: <linux-kernel-owner+w=401wt.eu-S1758070AbYILVyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070AbYILVyW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 17:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756809AbYILVyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 17:54:14 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:51193 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756757AbYILVyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 17:54:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=P26i1/YH3c5KTnVseDsDCrkGcIpekbWPvFHoxBRnubRxp566j/jcyfQj/nIteWyknJ
         fBz2OsNYK9jS00kR7O3L9Nmpri+tJnMXaGQTjR7eg/zjucW4KBpEIdDw+zc93Z5nE+F8
         +g9VYm/d4GVifVcab0/eWNckKSsAMECdLg888=
Message-ID: <86802c440809121454v5302d79ds8c6e1e6ca948059a@mail.gmail.com>
Date: Fri, 12 Sep 2008 14:54:12 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] apci: dump slit
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>, mingo@elte.hu,
       hpa@zytor.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080912213053.GR7714@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221243468-8016-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080912122031.eca8723e.akpm@linux-foundation.org>
	 <86802c440809121229i14727af4nd1416044b06ebb94@mail.gmail.com>
	 <878wtxrrwh.fsf@basil.nowhere.org>
	 <alpine.LFD.1.10.0809122313440.13819@apollo.tec.linutronix.de>
	 <20080912213053.GR7714@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2008 at 2:30 PM, Andi Kleen <andi@firstfloor.org> wrote:
>
> Yes excellent point.  Should we dump the complete ACPI tables?
> Do you prefer hexdump

good point. there is one time BIOS put blank slit there. (only have
acpi table header)
only after dump that earlier in kernel boot log, they shut up and go
back to fix their problem.

YH
