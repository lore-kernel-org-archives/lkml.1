Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbYCJT70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbYCJT70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 15:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbYCJT7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 15:59:19 -0400
Received: from phoenix.slamd64.com ([217.10.145.2]:33702 "EHLO
	phoenix.slamd64.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbYCJT7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 15:59:18 -0400
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: acer-wmi uses input:i8042_command() => build error
Date: Mon, 10 Mar 2008 19:59:06 +0000
User-Agent: KMail/1.9.7
Cc: linux-acpi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
References: <20080310124754.4ec3f24d.randy.dunlap@oracle.com>
In-Reply-To: <20080310124754.4ec3f24d.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803101959.06441.carlos@strangeworlds.co.uk>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (phoenix.slamd64.com [217.10.145.2]); Mon, 10 Mar 2008 19:59:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 March 2008 19:47:54 Randy Dunlap wrote:
> drivers/built-in.o: In function `set_u32':
> acer-wmi.c:(.text+0xb9bf6): undefined reference to `i8042_command'
> make[1]: *** [vmlinux] Error 1
> make: *** [sub-make] Error 2

It appears acer-wmi also depends on CONFIG_SERIO_I8042 for that function (I 
don't have CONFIG_EMBEDDED set so didn't notice that it could be disabled on 
x86).

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
