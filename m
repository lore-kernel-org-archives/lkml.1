Return-Path: <linux-kernel-owner+w=401wt.eu-S1764172AbXFENy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764172AbXFENy7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 09:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760529AbXFENyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 09:54:52 -0400
Received: from mail-secure01.communicationvalley.it ([194.246.127.20]:36146
	"EHLO communicationvalley.it" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760153AbXFENyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 09:54:51 -0400
From: Biker <biker@villagepeople.it>
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Subject: Re: WARNING: at mm/slab.c:777 __find_general_cachep() in 2.6.22-rc3
Date: Tue, 5 Jun 2007 15:54:31 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200706041229.37779.biker@villagepeople.it> <b6fcc0a0706040356x7cad92ecl51f4d1aec6a85624@mail.gmail.com>
In-Reply-To: <b6fcc0a0706040356x7cad92ecl51f4d1aec6a85624@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706051554.33719.biker@villagepeople.it>
x-pineapp-mail-mail-from: biker@villagepeople.it
x-pineapp-mail-rcpt-to: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 June 2007 12:56, Alexey Dobriyan wrote:
> On 6/4/07, Biker <biker@villagepeople.it> wrote:
> > WARNING: at mm/slab.c:777 __find_general_cachep()
> >  [<c016e0c4>]  [<f943288c>]  [<f9112bfa>]  [<f90f8546>]  [<c0104c90>]
> > [<c033702e>]  [<f90f15dd>]  [<f911de1d>]  [<f911e123>]  [<c01714d7>]
> > [<f911ba7c>]  [<f94300c9>]  [<f943016f>]  [<f9430157>]  [<c017d0bb>]
> > [<c0172741>]  [<c017d17c>]  [<c017d3fd>]  [<c01041c2>]
>
> Please, enable CONFIG_DEBUG_BUGVERBOSE, or decipher addresses
> into function calls yourself.

Eliminating the proprietary nvidia module seems to have resolved the issue. 
Sorry for the noise.

Biker
