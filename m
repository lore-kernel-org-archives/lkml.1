Return-Path: <linux-kernel-owner+w=401wt.eu-S1756539AbYBXCui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539AbYBXCui (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 21:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751187AbYBXCub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 21:50:31 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:53832 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbYBXCua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 21:50:30 -0500
Message-ID: <47C0DB2E.5000404@cs.helsinki.fi>
Date: Sun, 24 Feb 2008 04:49:18 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, sandmann@redhat.com, tglx@tglx.de, hpa@zytor.com
Subject: Re: [PATCH] x86: add the debugfs interface for the sysprof tool
References: <20080219123756.6261c13c@laptopd505.fenrus.org>	<20080223001130.d8922136.akpm@linux-foundation.org>	<84144f020802230351o24b11282vbb1cecf518d91825@mail.gmail.com> <20080223104611.a3430285.akpm@linux-foundation.org>
In-Reply-To: <20080223104611.a3430285.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Andrew Morton wrote:
> I didn't need to write a new kernel module to enable that
> thirteen-character shell script, and I don't believe one needs to write a
> new kernel module to put a nice easy-to-use GUI around oprofile either.
> 
> This is one of those i-cant-believe-im-having-this-discussion discussions.

Sysprof tracks the full stack frame so it can provide meaningful call 
tree (who called what) which is invaluable for spotting hot _paths_. I 
don't see how oprofile can do that as it tracks instruction pointers only.

			Pekka
