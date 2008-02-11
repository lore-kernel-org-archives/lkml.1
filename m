Return-Path: <linux-kernel-owner+w=401wt.eu-S1754980AbYBKMVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbYBKMVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 07:21:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbYBKMVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 07:21:25 -0500
Received: from ns.firmix.at ([62.141.48.66]:3936 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbYBKMVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 07:21:24 -0500
Subject: Re: [LINUX-KERNEL] C++ in linux kernel
From: Bernd Petrovitsch <bernd@firmix.at>
To: rohit h <hrohit85@gmail.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Joonwoo Park <joonwpark81@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <90d987c0802110337i42082a7ew905a096028fe347b@mail.gmail.com>
References: <90d987c0802072121v378da809l7b2690980566cd9@mail.gmail.com>
	 <b25c3fa70802080714m6236614i6b991dbb5d4aa20f@mail.gmail.com>
	 <Pine.LNX.4.64.0802081653560.26116@fbirervta.pbzchgretzou.qr>
	 <90d987c0802110337i42082a7ew905a096028fe347b@mail.gmail.com>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Mon, 11 Feb 2008 13:20:41 +0100
Message-Id: <1202732441.5221.17.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.329 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.329 required=5
X-Spam-Score: -2.329 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-02-11 at 17:07 +0530, rohit h wrote:
> On Feb 8, 2008 9:24 PM, Jan Engelhardt <jengelh@computergmbh.de> wrote:
[...]
> > Compiling the kernel module with g++ is not a simple work, you may
> > need big patch for kernel itself.
> 
> I don't want to compile entire kernel.
> I only want to compile my module with g++ and insmod it.
> Any hint on how to write the Makefile.

You really should learn on the differences at run-time between between
- pure C in a hosted environment (read: you have a full libc),
- pure C in a standalone environment (read: e.g. the Linux kernel), and
- C++ in both variants.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


