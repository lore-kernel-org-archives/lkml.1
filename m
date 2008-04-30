Return-Path: <linux-kernel-owner+w=401wt.eu-S932890AbYD3WSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932890AbYD3WSQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761233AbYD3WR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:17:59 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:44378 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760441AbYD3WR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:17:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=gBiJP7kl5Nv1C4dbBbWqN0hg0SG2eGKn3mLDdN0MM6is76712i2SA3cyp2Jp9fy3gwjP+T7kul7EE9aNNXnLrEs5uJJy6OgO6elZzNq4Kec17A7zqRuj9K+rUOExluo4drFHP4sxRMaug742c8luc0pK2jMc6EVUOb0c0AGRLa8=  ;
X-YMail-OSG: z2hCrHMVM1lCyK5FmI1t.S4j7_IHaQyghE_42NwMNYxO_3JRUAopeJ0pTEhxiM62fX53LNY43i9Io_2mDHvruAmIAQdom95EkpPQoEjgSGLx3YCHAQNU3mq9MR73V412fz8-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [patch] acpi: fix drivers/acpi/glue.c build error
Date: Wed, 30 Apr 2008 15:17:55 -0700
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <200804301420.11696.lenb@kernel.org> <20080430205615.GA23694@elte.hu> <20080430210026.GA24121@elte.hu>
In-Reply-To: <20080430210026.GA24121@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200804301517.56249.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 April 2008, Ingo Molnar wrote:
> Subject: acpi: fix drivers/acpi/glue.c build error
> From: Ingo Molnar <mingo@elte.hu>
> Date: Wed Apr 30 22:56:57 CEST 2008
> 
> x86.git testing found the following build bug:
> 
>   drivers/built-in.o: In function `acpi_rtc_init':
>   glue.c:(.init.text+0x16c3): undefined reference to `pnp_bus_type'
> 
> this tries to use PNP bus infrastructure even in the !PNP case.

Broken config, yes?  ACPI selects PNP ...
