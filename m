Return-Path: <linux-kernel-owner+w=401wt.eu-S1752786AbZIICGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbZIICGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 22:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbZIICGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 22:06:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54445 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751290AbZIICGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 22:06:17 -0400
Message-ID: <4AA70D4F.3040503@cn.fujitsu.com>
Date: Wed, 09 Sep 2009 10:05:03 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/4 -mm] flex_array: poison free elements
References: <alpine.DEB.2.00.0908211619270.28611@chino.kir.corp.google.com> <alpine.DEB.2.00.0908211620580.28611@chino.kir.corp.google.com> <1251129384.22398.7166.camel@nimitz> <alpine.DEB.2.00.0908241330361.5574@chino.kir.corp.google.com> <1251150156.22398.8289.camel@nimitz> <alpine.DEB.2.00.0908241540480.12448@chino.kir.corp.google.com> <alpine.DEB.1.00.0909081511590.26432@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.1.00.0909081511590.26432@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm struggling to find other examples.  Dave, do you know of any 
> subsystems in the kernel that can readily be converted to using flex 
> array?

Actually I'm planing to try to convert to use flex array in
kernel/trace/ftrace.c, and it needs some change in flex array,
and I'll have to check if it will have a performance effect
or not.

