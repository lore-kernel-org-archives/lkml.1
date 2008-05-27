Return-Path: <linux-kernel-owner+w=401wt.eu-S1757926AbYE0Xma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926AbYE0Xma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 19:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758356AbYE0XmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 19:42:10 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:11799 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760236AbYE0XmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 19:42:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=igqAvgJPIzXeFuaOyhhMScl/KzHJGNXtXIDoCH6BJlyDTRQfTCMJd2gD9qu1rWl0lbvwqfzMl8MasPxpYxL4TzBb2g3xa8KyKWwQf9qrHmjjfdGJ9oCAlax1xpeQcnLsFbh9SUzDTgEpEXHqvC/tvZr/D5P9XH7arBNLkf88iRY=
Message-ID: <12c511ca0805271641r68d50d3do9f6427a8dc6ad469@mail.gmail.com>
Date: Tue, 27 May 2008 16:41:59 -0700
From: "Tony Luck" <tony.luck@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] ACPI: add DMI info to enable OSI(Linux) on PRIMEQUEST
Cc: "Taku Izumi" <izumi.taku@jp.fujitsu.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080527162029.e549a226.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4816F9B9.3090609@jp.fujitsu.com> <4836660B.3080406@jp.fujitsu.com>
	 <483667A4.9000606@jp.fujitsu.com>
	 <20080527162029.e549a226.akpm@linux-foundation.org>
X-Google-Sender-Auth: 1f1f9d52e0dba62c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not sure that sharing drivers/acpi/blacklist.c between different
architectures is wise idea.  There are entries in there that make
blanket decisions for all machines made by an OEM.

It seems quite possible that an OEM that makes boxes using
different processor architectures might make different mistakes
in the respective BIOS teams.

-Tony
