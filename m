Return-Path: <linux-kernel-owner+w=401wt.eu-S1763962AbYEAQoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763962AbYEAQoW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 12:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759374AbYEAQoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 12:44:15 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:10604 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044AbYEAQoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 12:44:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=l9/veq/byubF4TISUSL+ECmky0hdHEUKzNiq1asKX2ADTCRyQAxscFQ+fXfTJ9x4JztmIqZgQLyDXFQj0qTIFv08E+yo+gN29S+5GnBvLMlZPSBX/lNjRCzS4iS2ChHXO/QuRPH7U2vNk6Bvzsbg1q9Z/zxT5ONO/HHeMDMAVgg=
Message-ID: <68676e00805010944y59fbbbdcyfd6524836997d3a1@mail.gmail.com>
Date: Thu, 1 May 2008 18:44:13 +0200
From: "Luca Tettamanti" <kronos.it@gmail.com>
To: "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>
Subject: Re: [BUG] smp alternatives: sleeping function called from invalid context
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <68676e00805010802s7b54f96ekbe637e5fb99dbd30@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080430195110.GA28743@dreamland.darkstar.lan>
	 <20080501130453.GA28965@Krystal>
	 <68676e00805010802s7b54f96ekbe637e5fb99dbd30@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 1, 2008 at 5:02 PM, Luca Tettamanti <kronos.it@gmail.com> wrote:
> On Thu, May 1, 2008 at 3:04 PM, Mathieu Desnoyers
>  <mathieu.desnoyers@polymtl.ca> wrote:
>  > * Luca Tettamanti (kronos.it@gmail.com) wrote:
>  >  > Hello,
>  >  > with git current I'm seeing these warnings when bringing CPUs down:
>  >  >
>  >
>  >
>  >  Hi Luca,
>  >
>  >  Does your tree include the patch posted here ?
>  >
>  >  http://lkml.org/lkml/2008/4/19/139
>
>  Nope, I was using vanilla kernel (smp_alt is still a spinlock). Will
>  test the patch ASAP.

Tested the patch: works fine, and the system is stable after multiple
up&down, I'm not experiencing a reboot.

Luca
