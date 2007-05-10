Return-Path: <linux-kernel-owner+w=401wt.eu-S1759631AbXEJRwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759631AbXEJRwB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 13:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758619AbXEJRvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 13:51:52 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:4127 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757287AbXEJRvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 13:51:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fgmsezB/D9GR3LEZ70XWbiTXjpSzigkfJEY3eSP6vnnPDJ906wSqXLRJ+ykbdSRg1nmxR11m0t4HKy7TsH3rfdu++wZkBldZ1nSUuqbmw8EZjT+Z9p53bC8CjI00QQ/VQGt9hKlDQFAxa+8R4WVnLfd6CjN6Khjxa8GJg3cFuyY=
Message-ID: <f383264b0705101051r4c8ebc73hc7f6119393fe46c9@mail.gmail.com>
Date: Thu, 10 May 2007 10:51:50 -0700
From: "Matt Reimer" <mattjreimer@gmail.com>
To: "Haavard Skinnemoen" <hskinnemoen@atmel.com>
Subject: Re: [PATCH] MMC: Flush mmc workqueue late in the boot sequence
Cc: "Pierre Ossman" <drzeus@drzeus.cx>, linux-kernel@vger.kernel.org
In-Reply-To: <20070510182749.219351cb@dhcp-252-105.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <117879333788-git-send-email-hskinnemoen@atmel.com>
	 <46430A49.9090803@drzeus.cx>
	 <20070510143737.54969394@dhcp-252-105.norway.atmel.com>
	 <46432212.9070008@drzeus.cx>
	 <20070510163348.0a117d92@dhcp-252-105.norway.atmel.com>
	 <46434123.8040801@drzeus.cx>
	 <20070510182749.219351cb@dhcp-252-105.norway.atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/10/07, Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
> Btw, how can I wait for the scanning to complete from early userspace?

A workaround is to pass the kernel argument rootdelay=5 or something
like that (the value specifies seconds).

Matt
