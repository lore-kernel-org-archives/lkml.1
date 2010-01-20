Return-Path: <linux-kernel-owner+w=401wt.eu-S1756268Ab0ATCP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268Ab0ATCP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 21:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756168Ab0ATCP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 21:15:28 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:33778 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122Ab0ATCP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 21:15:27 -0500
MIME-Version: 1.0
In-Reply-To: <6278d2221001191810m21f4cca1id3535de0bb677196@mail.gmail.com>
References: <6278d2221001191810m21f4cca1id3535de0bb677196@mail.gmail.com>
Date: Wed, 20 Jan 2010 10:15:24 +0800
Message-ID: <d3f22a1001191815j317d190bu460ab71cd0200808@mail.gmail.com>
Subject: Re: [2.6.33-rc4] ACPI hitting kmalloc(MAX_ORDER) limits...
From: Lin Ming <lin@minggr.cn>
To: Daniel J Blueman <daniel.blueman@gmail.com>, achiang@hp.com
Cc: linux-acpi@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 10:10 AM, Daniel J Blueman
<daniel.blueman@gmail.com> wrote:
> When booting 2.6.33-rc4 on an Ibase MI910 miniITX x86-64 mobo, ACPI
> hits kmalloc MAX_ORDER limits [1] while parsing the AML; though a
> warning, it is a regression over 2.6.32.
>
> Would making the AML available help adding this to a testcase?

This issue has been resolved.
See http://bugzilla.kernel.org/show_bug.cgi?id=14954

Lin Ming
