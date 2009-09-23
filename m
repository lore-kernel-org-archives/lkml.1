Return-Path: <linux-kernel-owner+w=401wt.eu-S1754229AbZIWHEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbZIWHEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 03:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbZIWHEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 03:04:44 -0400
Received: from mail-gw.exalead.com ([193.47.80.29]:35265 "EHLO exalead.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751602AbZIWHEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 03:04:43 -0400
Message-ID: <4AB9C879.1090709@exalead.com>
Date: Wed, 23 Sep 2009 09:04:25 +0200
From: Xavier Roche <roche+kml2@exalead.com>
Organization: Exalead
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.22) Gecko/20090606 SeaMonkey/1.1.17
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Inter-process send()/recv() using zero-copy ?
References: <4AB9B9B7.1020309@exalead.com> <20090923084314.78283f24@infradead.org>
In-Reply-To: <20090923084314.78283f24@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> 1) memory copies are cheap
>    (say, 3000 cycles/page or less)

Yes, but this case would be more than useful for large memory blocks 
(typically memory_size/N, with N typically 2..10) -- something you 
generally have when you deal with mmap'ed blocks.
