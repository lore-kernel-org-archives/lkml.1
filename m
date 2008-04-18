Return-Path: <linux-kernel-owner+w=401wt.eu-S1752342AbYDRH1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbYDRH1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 03:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbYDRH1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 03:27:08 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:40465 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266AbYDRH1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 03:27:07 -0400
Message-ID: <48084CE4.60109@cs.helsinki.fi>
Date: Fri, 18 Apr 2008 10:25:24 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: 2.6.25-mm1: not looking good
References: <20080417160331.b4729f0c.akpm@linux-foundation.org> <84144f020804172340l79f9c815u42e4dad69dada299@mail.gmail.com> <20080418072457.GB18044@elte.hu>
In-Reply-To: <20080418072457.GB18044@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> hm, there's sel_netnode_free() in the stackframe - that's from 
> security/selinux/netnode.c. Andrew, any recent changes in that area?

Keep in mind that slab might have been corrupted by someone else much 
earlier but we didn't notice due to the lack of CONFIG_SLAB_DEBUG.
