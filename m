Return-Path: <linux-kernel-owner+w=401wt.eu-S1756125AbZKDN1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125AbZKDN1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 08:27:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755259AbZKDN1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 08:27:52 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34538
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755101AbZKDN1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 08:27:51 -0500
Date: Wed, 04 Nov 2009 05:28:16 -0800 (PST)
Message-Id: <20091104.052816.74593826.davem@davemloft.net>
To: gilad@codefidence.com
Cc: Valdis.Kletnieks@vt.edu, netdev@vger.kernel.org, ori@comsleep.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] Use defaults when no route options are available
From: David Miller <davem@davemloft.net>
In-Reply-To: <1257276085-13681-1-git-send-email-gilad@codefidence.com>
References: <4AF07024.80103@gmail.com>
	<1257276085-13681-1-git-send-email-gilad@codefidence.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gilad Ben-Yossef <gilad@codefidence.com>
Date: Tue,  3 Nov 2009 21:21:25 +0200

> Trying to parse the option of a SYN packet that we have
> no route entry for should just use global wide defaults
> for route entry options.
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@codefidence.com>

The tester has indicated that this doesn't solve things
for them.  I suspect there is another dependency on 'dst'
not being NULL in another path somewhere.

So until this is fully resolved I'm holding off on applying
this patch.
