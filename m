Return-Path: <linux-kernel-owner+w=401wt.eu-S1755811Ab0ASLQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab0ASLQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 06:16:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755059Ab0ASLQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 06:16:27 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:61069 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123Ab0ASLQ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 06:16:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=o5OQGR9ZWiGMQkNIv8oGRaVUjR3jnfQPS/agQ9+4/z6vi9Q+GTJJSSzV/kdAnsadMs
         Q3Dee5i2P+b8Ex5z829/R2sqejc6MVoeZ3BBHRuvQ1pGvgoppIahifbvPF2eGxJkctEy
         p8olU/D6scYiZ+8OMON8/9qiQVDXxrG79011o=
MIME-Version: 1.0
In-Reply-To: <1252950229-9629-1-git-send-email-vapier@gentoo.org>
References: <1252905504-26666-1-git-send-email-vapier@gentoo.org> 
	<1252950229-9629-1-git-send-email-vapier@gentoo.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 19 Jan 2010 06:16:05 -0500
Message-ID: <8bd0f97a1001190316k6167ad39h20be3343aba3acb8@mail.gmail.com>
Subject: Re: [PATCH v2] [Bluetooth] redo checks in IRQ handler for shared IRQ 
	support
To: linux-bluetooth@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
Cc: linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 12:43, Mike Frysinger wrote:
> Commit ac019360fe3 changed the irq handler logic to BUG_ON rather than
> returning IRQ_NONE when the incoming argument is invalid.  While this
> works in most cases, it doesn't work when the IRQ is shared with other
> devices (or when DEBUG_SHIRQ is enabled).
>
> So revert the previous change and replace the warning message with a
> comment explaining that we want this behavior.

was this picked up ?
-mike
