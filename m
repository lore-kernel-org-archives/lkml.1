Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891AbZAFUhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbZAFUhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 15:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbZAFUhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 15:37:04 -0500
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:46836 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751002AbZAFUhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 15:37:03 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=VemBIF2UCcqAJbddgopBeCa9yKmYDoZ2HOISMX5tjsRn1Cfp6H8a2wRfD8HCwDYaJYO5cLQdMSmGKhCDxk57FhyWNSb9zvj6n0pYgT9IwmnYiZeU5N5d0DsZjdNOe5uesQ30tX1qzcau0rOCFARV6U6N6Pof6g7vNhKYFZcwHRw=  ;
X-YMail-OSG: upVvcdAVM1ky9JEvGiYdUDrT_IioTc2fvp4GDZ3QeJZ12v2xnvumMeTNkKO4Wug5HoOVMwoTH0HI51JUT23ayJ5MbFOjMwyKIpyiMIAjrcEba.h5R5Now9B2jFOKuQTaeGJAur4j9Neo8ywdydQu4ZxsPdm4QEnTtLfM.hhptw2ps4.bRrV90EpnjRWhGa211g--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2.6.28-rc2] CORE_DUMP_DEFAULT_ELF_HEADERS depends on ELF_CORE
Date: Tue, 6 Jan 2009 12:37:00 -0800
User-Agent: KMail/1.9.10
Cc: Roland McGrath <roland@redhat.com>
References: <200810301559.50467.david-b@pacbell.net>
In-Reply-To: <200810301559.50467.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901061237.01020.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 October 2008, David Brownell wrote:
> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Kernels that don't support ELF coredumps at all surely can't
> be supporting new partial-segment flavored ELF coredumps ...
> don't make folk answer Kconfig questions about that flavor.

PING?

> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> Cc: Roland McGrath <roland@redhat.com>
> ---
>  fs/Kconfig.binfmt |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/fs/Kconfig.binfmt
> +++ b/fs/Kconfig.binfmt
> @@ -43,7 +43,7 @@ config BINFMT_ELF_FDPIC
>  config CORE_DUMP_DEFAULT_ELF_HEADERS
>  	bool "Write ELF core dumps with partial segments"
>  	default n
> -	depends on BINFMT_ELF
> +	depends on BINFMT_ELF && ELF_CORE
>  	help
>  	  ELF core dump files describe each memory mapping of the crashed
>  	  process, and can contain or omit the memory contents of each one.
> 


