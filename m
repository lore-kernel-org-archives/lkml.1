Return-Path: <linux-kernel-owner+w=401wt.eu-S1753073AbYCLJSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073AbYCLJSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 05:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbYCLJRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 05:17:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55142 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbYCLJRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 05:17:52 -0400
Date: Wed, 12 Mar 2008 10:19:50 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andi Kleen <andi@firstfloor.org>, andreas.herrmann3@amd.com,
       tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [4/7] Don't use large pages to map the first 2/4MB of memory
Message-ID: <20080312091950.GB31389@one.firstfloor.org>
References: <20080312353.598285931@firstfloor.org> <20080312025330.AC1961B41D1@basil.firstfloor.org> <47D76C72.2080603@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D76C72.2080603@cosmosbay.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Should we then change CONFIG_PHYSICAL_START from 0x100000 to 0x400000 ?

Yes that would be probably a good idea. This means for PAE and 64bit
kernels 2MB is ok too, for i386 non PAE 4MB. The SUSE 64bit kernels have been 
using that for quite some time.

-Andi
