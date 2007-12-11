Return-Path: <linux-kernel-owner+w=401wt.eu-S1755305AbXLKTOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbXLKTOK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 14:14:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752931AbXLKTN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 14:13:57 -0500
Received: from smtp-out.google.com ([216.239.45.13]:26724 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbXLKTN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 14:13:56 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=sF4V2imCRKrLovEYrDg5iqPvEGWyYGguNnlsnNlgk0Wcdt3K8lIUPVCDLqTKgXyK2
	pc+ukVHZiqoo6SXMuuRlA==
Message-ID: <3f1a065b0712111113x56b81b0dv9af1cda8491def4a@mail.gmail.com>
Date: Tue, 11 Dec 2007 11:13:45 -0800
From: "Russell Leidich" <rml@google.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AMD Thermal Interrupt Support
In-Reply-To: <3f1a065b0712111044p4270c756qcc5aaee922cfbd12@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3f1a065b0712111044p4270c756qcc5aaee922cfbd12@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am reapplying this patch to 2.6.24.  I will send an update when it's done.

On Dec 11, 2007 10:44 AM, Russell Leidich <rml@google.com> wrote:
> This patch adds thermal interrupt logging support for AMD Barcelona to
> 2.6.18.  In the style of the existing Intel implementation, thermal
> interrupts are logged as machine checks.  Interrupts are logged only
> when throttling is activated, i.e. when the package gets too hot.
>
> Files affected:
>
> 2.6.18/arch/x86-64/kernel/Makefile
> 2.6.18/arch/x86-64/kernel/mce_amd.c
> 2.6.18/arch/x86-64/kernel/mce_intel.c
> 2.6.18/arch/x86-64/kernel/mce_thermal.c (new)
> 2.6.18/include/asm-x86-64/kernel/mce.h
>
> Signed-off-by: Russell Leidich <rml@google.com>
>
> --
> Russell Leidich
>



-- 
Russell Leidich
