Return-Path: <linux-kernel-owner+w=401wt.eu-S1760078AbYASNtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760078AbYASNtk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 08:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbYASNtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 08:49:33 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:44811 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbYASNtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 08:49:32 -0500
Date: Sat, 19 Jan 2008 14:49:31 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Rafael Sisto <rafael.sisto@gmail.com>
cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: new file in kernel.
In-Reply-To: <ee3dc96c0801190542u2f91a2eax3bcfd0268d4850b4@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0801191448140.27831@fbirervta.pbzchgretzou.qr>
References: <ee3dc96c0801190542u2f91a2eax3bcfd0268d4850b4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 19 2008 10:42, Rafael Sisto wrote:
>Dear forum,
>can anybody help me with this issue?
>
>How do I create a new file in kernel mode?
>I am trying to create a file in a system call I am building.

http://kernelnewbies.org/FAQ/WhyWritingFilesFromKernelIsBad

Even then, you are a bit too unspecific. A syscall could
very well call a filesystem's create function and create
a file that way, though it is a very different use-case.
