Return-Path: <linux-kernel-owner+w=401wt.eu-S1758413AbYHZLK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758413AbYHZLK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 07:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756403AbYHZLKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 07:10:14 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56812 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755457AbYHZLKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 07:10:13 -0400
Date: Tue, 26 Aug 2008 11:52:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Frans Meulenbroeks" <fransmeulenbroeks@gmail.com>
Cc: "Avi Kivity" <avi@qumranet.com>, "Pavel Machek" <pavel@suse.cz>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] x86: default to reboot via ACPI
Message-ID: <20080826115250.02004aea@lxorguk.ukuu.org.uk>
In-Reply-To: <ac9c93b10808260403ga9f6e13v4792bb2c13dfc2bf@mail.gmail.com>
References: <1219659087-17536-1-git-send-email-avi@qumranet.com>
	<20080826095032.GA309@elf.ucw.cz>
	<48B3D579.40502@qumranet.com>
	<ac9c93b10808260403ga9f6e13v4792bb2c13dfc2bf@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Linux is used a lot in embedded systems (like routers and NAS-es and
> probably set-top boxes). I guess the # of embedded systems with some
> linux flavour on it is substantially bigger than the desktop systems.
> Most of these are ARM or MIPS based and do not support ACPI.

They also don't support VT and are not x86 boxes so the code area
involved doesn't even get compiled on them.
