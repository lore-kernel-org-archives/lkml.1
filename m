Return-Path: <linux-kernel-owner+w=401wt.eu-S1756224AbYA3CdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbYA3CdW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 21:33:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbYA3CdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 21:33:05 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:65209 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322AbYA3CdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 21:33:04 -0500
Date: Tue, 29 Jan 2008 18:39:52 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH 2/4] x86_64: make early_node_mem return align address v2
In-reply-to: <200801291114.49030.yinghai.lu@sun.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Message-id: <200801291839.53450.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801291113.35974.yinghai.lu@sun.com>
 <200801291114.49030.yinghai.lu@sun.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 January 2008 11:14:48 am Yinghai Lu wrote:
> [PATCH 2/4] x86_64: make early_node_mem return align address v2
> 
> boot oops when system get 64g or 128 installed
> 

can you apply this updated version with others?

setup_node_mem should return with PAGE_ALIGN.

in setup_node_bootmem, it need bootmap_start to be PAGE_ALIGN, without this patch it will overlap with bss.

YH
