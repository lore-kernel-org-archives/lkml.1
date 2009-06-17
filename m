Return-Path: <linux-kernel-owner+w=401wt.eu-S1762193AbZFQGku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762193AbZFQGku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 02:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbZFQGkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 02:40:41 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:25541 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbZFQGkk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 02:40:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=L3N9GHKyNyT3Brpx04ALSuDCg+EQNu3a+5g8Ly0TO+AAYSMO6xKq3lrrZIkfbEo5sg
         aSVJrKOUVCQxuTK0gsKqxC6OPqLpBXb3gEfRRraNTNcN3pTEjeK7DvrbC7caq32Q7NWW
         /FeBryk/ZVrg2zsDZr3MtK4FdMsld7anQl4Rc=
MIME-Version: 1.0
In-Reply-To: <20090617005318.1e35ae98@dragos-tp.localdomain>
References: <20090617005318.1e35ae98@dragos-tp.localdomain>
Date: Tue, 16 Jun 2009 23:40:42 -0700
X-Google-Sender-Auth: 99bf80052d39c898
Message-ID: <e9c3a7c20906162340o141d04e6n36b5b7b4a2513270@mail.gmail.com>
Subject: Re: DMA_ENGINE: can't use it without selecting a dma engine driver
From: Dan Williams <dan.j.williams@intel.com>
To: Dragos Tatulea <dtatulea@ixiacom.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 2:53 PM, Dragos Tatulea<dtatulea@ixiacom.com> wrote:
> Hi,
>
>        Just discovered that it's impossible to select the dma engine without
>        compiling a dma engine driver from the kernel. What if I want to use a
>        different dma engine?
>

Create a Kconfig entry for your driver in drivers/dma/Kconfig and have
it "select DMA_ENGINE".
