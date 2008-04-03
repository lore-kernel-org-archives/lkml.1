Return-Path: <linux-kernel-owner+w=401wt.eu-S1758044AbYDCNPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044AbYDCNPc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 09:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757551AbYDCNO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 09:14:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757511AbYDCNO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 09:14:58 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <47F4BA31.1080702@t-online.de>
References: <47F4BA31.1080702@t-online.de> <8bd0f97a0804011434r4869fbe8t89ade12c04c97f2@mail.gmail.com> <5516.1207146014@redhat.com> <8bd0f97a0804020747r2d7c2802pa18cf08eced3821b@mail.gmail.com> <47F3A02B.5070302@t-online.de> <8bd0f97a0804020807o21f69b7due910563b9dad03e8@mail.gmail.com>
To: Bernd Schmidt <bernds_cb1@t-online.de>
Cc: dhowells@redhat.com, Mike Frysinger <vapier.adi@gmail.com>,
       Greg Ungerer <gerg@snapgear.com>,
       David McCullough <David_Mccullough@securecomputing.com>,
       LKML <linux-kernel@vger.kernel.org>, Bryan Wu <Bryan.Wu@analog.com>,
       Robin Getz <rgetz@blackfin.uclinux.org>
Subject: Re: nommu: handling anonymous mmap clearing in userspace rather than kernel
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Thu, 03 Apr 2008 14:14:11 +0100
Message-ID: <21218.1207228451@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Schmidt <bernds_cb1@t-online.de> wrote:

> Really, if MAP_UNINITIALIZE is unacceptable, then that's too bad and we'll
> carry it as a local patch, but all the other proposed mechanisms are
> non-solutions because they break an established interface.

Agreed.  The kernel would not be backwardly compatible with old userspaces.

David
