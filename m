Return-Path: <linux-kernel-owner+w=401wt.eu-S1760105AbYBFEAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760105AbYBFEAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 23:00:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757666AbYBFEAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 23:00:43 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:61658 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757575AbYBFEAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 23:00:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=d4Ivy0MPQhK5jdXLwKwzXG89oGCMLt0Jc33MWUiQS2F+bsTpiPHTrEXNZLrP46UKLw+sgYh7s/p67TpJcnAoJ2taMtEq6X5TmsLj++VQD6GvhUk4E9zOpcGuzl2vnKujBYtW6la4dsA79EwgZsQIvtWLb3VaDwNyKluiHs/DBbw=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: hasan@digitalpath.net
Subject: Re: Access MSR functions in userspace?
Date: Wed, 6 Feb 2008 06:00:35 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20080118.763038)
Cc: linux-kernel@vger.kernel.org
References: <3278.65.164.104.9.1202268587.squirrel@webmail.digitalpath.net>
In-Reply-To: <3278.65.164.104.9.1202268587.squirrel@webmail.digitalpath.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802060600.35498.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 6 February 2008 05:29:47 Hasan Rashid wrote:
> Is there a way to use RDMSR and WRMSR in userspace? I only need to write
> to one register, writing a module with a userspace piece to handle that
> seems like an over kill.
> 
> TIA!


Fortunately linux have /dev/cpu/*/msr
Take  look at $LINUX_SOURCES/arch/x86/kernel/msr.c to learn how to use it.

Best regards,
	Maxim Levitsky
