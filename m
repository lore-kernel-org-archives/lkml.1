Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436Ab0AYKLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab0AYKLm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 05:11:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221Ab0AYKLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 05:11:41 -0500
Received: from mga10.intel.com ([192.55.52.92]:21401 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753171Ab0AYKLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 05:11:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,338,1262592000"; 
   d="scan'208";a="534239562"
Message-ID: <4B5D6E56.80108@linux.intel.com>
Date: Mon, 25 Jan 2010 11:11:34 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Stefani Seibold <stefani@seibold.net>
CC: Thiago Farina <tfransosi@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] kernel/kfifo.c: fix "interger as NULL pointer" warning.
References: <1264349038-1766-1-git-send-email-tfransosi@gmail.com> <1264353324.5592.1.camel@wall-e>
In-Reply-To: <1264353324.5592.1.camel@wall-e>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefani Seibold wrote:
> Am Sonntag, den 24.01.2010, 11:03 -0500 schrieb Thiago Farina:
>> kernel/kfifo.c:83:35: warning: Using plain integer as NULL pointer
>>
> 
> I don't know where you get this kind of warning. But passing 0 for a
> NULL pointer is ANSI C standard.

It's not "Linus C", as implemented in sparse unfortunately.

-Andi
