Return-Path: <linux-kernel-owner+w=401wt.eu-S932940AbXAWKhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932940AbXAWKhK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 05:37:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932942AbXAWKhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 05:37:10 -0500
Received: from an-out-0708.google.com ([209.85.132.242]:39027 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932940AbXAWKhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 05:37:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nOQXPdfX0DX/Tpqqq8ldal16aUGJPC61pBjz5jRmkZyu9hhvJIgvGPilQaykx+Pf5rCJBal1mvjCERm9u056aGOkSVILUT+VF7o46mP2+ZtYiQDnYRUbe9qI1YuULQvDNY/gepIfwZkdON3Sj5s0xLTQqWmVSmEPVGhnYAcI9OI=
Message-ID: <9e0cf0bf0701230237j5aa1bbya3a70da314e471b9@mail.gmail.com>
Date: Tue, 23 Jan 2007 12:37:06 +0200
From: "Alon Bar-Lev" <alon.barlev@gmail.com>
To: "Tomas Carnecky" <tom@dbservice.com>, linux-kernel@vger.kernel.org,
       "Alon Bar-Lev" <alon.barlev@gmail.com>
Subject: Re: [patch 03/26] Dynamic kernel command-line - arm
In-Reply-To: <20070122222725.GB32085@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070118125849.441998000@strauss.suse.de>
	 <20070118130028.719472000@strauss.suse.de>
	 <20070118141359.GB31418@flint.arm.linux.org.uk>
	 <45AF92E7.50901@dbservice.com>
	 <20070118152326.GC31418@flint.arm.linux.org.uk>
	 <20070122221400.GE6262@strauss.suse.de>
	 <20070122222725.GB32085@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/23/07, Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> which reflects precisely what I've been saying concerning the addition
> of __initdata.

Great!
So what do you thing we should do?

Modify this:
char __initdata boot_command_line[COMMAND_LINE_SIZE];

Into:
char __initdata boot_command_line[COMMAND_LINE_SIZE] = {0};

Or:
static char __initdata _boot_command_line[COMMAND_LINE_SIZE];
char __initdata *boot_command_line = _boot_command_line;

Or any other option... I will glad to receive any convention you see right.

Best Regards,
Alon Bar-Lev.
