Return-Path: <linux-kernel-owner+w=401wt.eu-S940758AbXGSRiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940758AbXGSRiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760124AbXGSRiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:38:20 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:24633 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762400AbXGSRiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:38:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bslT84mcy7MljJ3rnKX02xQPY1OFTlz7lK3nnnVSZ4LxpuQgyCF63ztO+9RkLZGHCvK97EHWv8W1HMG8Upu1pgkhT9gNLtCl2SeKvzZ6neHSiD2dpfRz3pzempAQqbhGJp9hbCwkQyap1sq8MyWboFiHAcwJw1UiA6lsgMWEMWc=
Message-ID: <86802c440707191038x7b37f949i6e1ff903ccc51b4f@mail.gmail.com>
Date: Thu, 19 Jul 2007 10:38:16 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH] [7/58] x86_64: various cleanups in NUMA scan node
Cc: rientjes@google.com, patches@x86-64.org, linux-kernel@vger.kernel.org
In-Reply-To: <200707191921.22909.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707191154.642492000@suse.de>
	 <20070719095451.3578E14E04@wotan.suse.de>
	 <86802c440707191015u4c6b0e72u17c7674593fb1085@mail.gmail.com>
	 <200707191921.22909.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/19/07, Andi Kleen <ak@suse.de> wrote:
>
> > do we need to put __initdata just before =?
>
> AFAIK gcc __attribute__ syntax allows both. It certainly seems to compile.

in include/linux/init.h

it said

"
 * For initialized data:
 * You should insert __initdata between the variable name and equal
 * sign followed by value, e.g.:
 *
 * static int init_variable __initdata = 0;
 * static char linux_logo[] __initdata = { 0x32, 0x36, ... };
"

or we need to update these lines?

YH
