Return-Path: <linux-kernel-owner+w=401wt.eu-S1759635AbYGPVoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759635AbYGPVoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 17:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757471AbYGPVoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 17:44:25 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:50866 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202AbYGPVoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 17:44:24 -0400
Subject: Re: kvm causing memory corruption?  now 2.6.26
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Avi Kivity <avi@qumranet.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm@vger.kernel.org>,
       "Anthony N. Liguori [imap]" <aliguori@us.ibm.com>
In-Reply-To: <1216148242.25942.6.camel@nimitz>
References: <1206479576.7562.21.camel@nimitz.home.sr71.net>
	 <47EA1C63.8010202@qumranet.com>
	 <1206550329.7883.5.camel@nimitz.home.sr71.net>
	 <47EA80AC.4070204@qumranet.com>
	 <1206551794.7883.7.camel@nimitz.home.sr71.net>
	 <47EB6AAC.3040607@qumranet.com>  <47EB7281.6070300@qumranet.com>
	 <1206629709.7883.30.camel@nimitz.home.sr71.net>
	 <47EBB63E.2060306@qumranet.com>
	 <1212445810.8211.9.camel@nimitz.home.sr71.net>
	 <48469BDA.3050206@qumranet.com> <1212738105.7837.3.camel@nimitz>
	 <48512028.3070104@qumranet.com>  <1216148242.25942.6.camel@nimitz>
Content-Type: text/plain
Date: Wed, 16 Jul 2008 14:44:20 -0700
Message-Id: <1216244660.8711.6.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a suggestion of Anthony's, I tried a defconfig kernel.

It is now bombing out on an assertion in the lapic code:

	http://sr71.net/~dave/linux/2.6.26-oops1.txt



-- Dave

