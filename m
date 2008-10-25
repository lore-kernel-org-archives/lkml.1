Return-Path: <linux-kernel-owner+w=401wt.eu-S1753366AbYJYOFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbYJYOFw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 10:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbYJYOFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 10:05:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:37296 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbYJYOFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 10:05:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,483,1220252400"; 
   d="scan'208";a="455426995"
Message-ID: <490327B6.2090903@linux.intel.com>
Date: Sat, 25 Oct 2008 07:05:42 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: "Carlos R. Mafra" <crmafra2@gmail.com>
CC: linux-kernel@vger.kernel.org,
       "arjan@infradead.org >> Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [2.6.28-rc1 regression] wmifinfo dockapp takes 100% of cpu	(bisected)
References: <20081025094043.GA4438@localhost.aei.mpg.de>
In-Reply-To: <20081025094043.GA4438@localhost.aei.mpg.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Carlos R. Mafra wrote:


Hi,

the line below is the key one:

> select(4, [3], NULL, NULL, {0, 5000000}) = -1 EINVAL (Invalid argument)

the application gives us an invalid timeval; it should have been (5, 0)
However, if the kernel accepted this before the kernel needs to now also accept it
obviously, I'll
