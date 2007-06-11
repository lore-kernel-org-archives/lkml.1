Return-Path: <linux-kernel-owner+w=401wt.eu-S1757507AbXFKTxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507AbXFKTxn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 15:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbXFKTxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 15:53:36 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:40614 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbXFKTxf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 15:53:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Tgdx1oNU2MprXtvhzP5S39ZnISOxPx5zBAoRXsetN6rsoHpL3RbhA2/fSSydbeNAPY6+G/YzqDnnhYodb7Bj/bZlwNbf1AxKEfcqbEOzYt+u9J5d3Y3lswYwndHvupntZBqlWp8VnYc9Ze1FdFyWIEpLhzEmG5SfzK+ujqRSMdI=
Message-ID: <1defaf580706111253q2a4910b1v4802436e32e94953@mail.gmail.com>
Date: Mon, 11 Jun 2007 21:53:32 +0200
From: "=?ISO-8859-1?Q?H=E5vard_Skinnemoen?=" <hskinnemoen@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: kernel BUG at mm/slub.c:3689!
Cc: "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "David Brownell" <david-b@pacbell.net>
In-Reply-To: <Pine.LNX.4.64.0706111239230.19654@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20070611161926.2a9f8efd@dhcp-255-175.norway.atmel.com>
	 <Pine.LNX.4.64.0706110946430.15910@schroedinger.engr.sgi.com>
	 <1defaf580706111011w641b26fbu68d6d34028f6e953@mail.gmail.com>
	 <Pine.LNX.4.64.0706111041160.17264@schroedinger.engr.sgi.com>
	 <1defaf580706111122n78ab46c3sda05cbd4ace97319@mail.gmail.com>
	 <Pine.LNX.4.64.0706111129270.18327@schroedinger.engr.sgi.com>
	 <1defaf580706111204v35b4dcc9j5dc68e722bd384b1@mail.gmail.com>
	 <Pine.LNX.4.64.0706111208580.19316@schroedinger.engr.sgi.com>
	 <1defaf580706111235p7da29d25xc33d221134f3f7a8@mail.gmail.com>
	 <Pine.LNX.4.64.0706111239230.19654@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/11/07, Christoph Lameter <clameter@sgi.com> wrote:
> Trouble is that ARCH_KMALLOC_MINALIGN is in bytes whereas we would need a
> shift value for KMALLOC_MIN_SHIFT.

Ah, of course. Hrm...I just thought I had an idea, but it wouldn't work...

> Does the latest patch work?

I'm sorry, but I haven't tested it yet. My board needs a hard reset,
and I can't do that over VPN. I'll test it first thing in the morning.

Håvard
