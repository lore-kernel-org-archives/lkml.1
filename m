Return-Path: <linux-kernel-owner+w=401wt.eu-S1759090AbYGUCTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759090AbYGUCTu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 22:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758893AbYGUCTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 22:19:39 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:9876 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758895AbYGUCTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 22:19:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=L/eDx2UyTSLZMefbsJaSb/ikgW5ctQH9wkoU1KZDMQlZxgj05Z55ZyUub0JIo3zNX5
         A9EXXEqizbP9tN4gUrHOysnWBglERtTiSjiHYspPPMK4T0Lvba8rp0GCmo3plR0bC9sw
         SEoM0IYR9aF1WGXykInOfLf+aC8khTbv56xOo=
Message-ID: <8bd0f97a0807201919l693e0978rab627f92a72f17f5@mail.gmail.com>
Date: Sun, 20 Jul 2008 22:19:38 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: nuclearcat@nuclearcat.com
Subject: Re: blackfin and USB
Cc: linux-kernel@vger.kernel.org, idan@nicta.com.au,
       rgetz@blackfin.uclinux.org, cooloney@kernel.org
In-Reply-To: <200807210455.38681.nuclearcat@nuclearcat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807210455.38681.nuclearcat@nuclearcat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2008 at 9:55 PM,  <nuclearcat@nuclearcat.com> wrote:
> I am trying to configure kernel for Blackfin (BF533). I cannot enable USB driver for host (any)

add this to drivers/usb/Kconfig:USB_ARCH_HAS_HCD
default y if BLACKFIN

> till i enable PCI (and in fact there is no PCI on blackfin).
> Even if i enable it, i will have:

dont enable it

> Btw is networking works on Blackfin with vanilla?

"networking" works.  specific driver is up to you to see if it works.
-mike
