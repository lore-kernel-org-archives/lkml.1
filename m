Return-Path: <linux-kernel-owner+w=401wt.eu-S934186AbYBGV3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934186AbYBGV3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:29:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754362AbYBGV25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 16:28:57 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:40569 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611AbYBGV2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 16:28:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=MBng0AmBjcG8Cg5KKJyBB7VtKWm4zTBspqaHj2JHuhcQC35KunZXv1N56z+pVs+p8VJfA7or1Gb10nRbaK+vWxElNqTWoICFG579t0Oc7FOoCWrLm6jDjnNyRrRES9L6o8Mqr86KjN+vAxA4CqeIJk7Xtuki5lX0i65v5u8uOrA=
Message-ID: <47AB7813.7050807@gmail.com>
Date: Thu, 07 Feb 2008 22:28:51 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: benh@kernel.crashing.org
CC: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       Grant Likely <grant.likely@secretlab.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Xilinx: hwicap driver comments
References: <47AB6552.7040503@gmail.com> <1202419066.7079.130.camel@pasglop>
In-Reply-To: <1202419066.7079.130.camel@pasglop>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2008 10:17 PM, Benjamin Herrenschmidt wrote:
> On Thu, 2008-02-07 at 21:08 +0100, Jiri Slaby wrote:
>> - io resources are at least ulong
> 
> They should actually be resource_size_t :-)

Yup, should... [I don't know how ofter people have 64bit resources on 32 bit 
this becomes a problem.]
