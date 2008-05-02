Return-Path: <linux-kernel-owner+w=401wt.eu-S934366AbYEBLNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934366AbYEBLNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 07:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758283AbYEBLNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 07:13:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37703
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755424AbYEBLM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 07:12:59 -0400
Date: Fri, 02 May 2008 04:12:58 -0700 (PDT)
Message-Id: <20080502.041258.45260088.davem@davemloft.net>
To: den@openvz.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       adobriyan@openvz.org, ebiederm@xmission.com
Subject: Re: [PATCH 12/12] netns: assign PDE->data before gluing entry into
 /proc tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <1209467602-20001-12-git-send-email-den@openvz.org>
References: <1209467538.29647.11.camel@iris.sw.ru>
	<1209467602-20001-12-git-send-email-den@openvz.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Denis V. Lunev" <den@openvz.org>
Date: Tue, 29 Apr 2008 15:13:22 +0400

> In this unfortunate case, proc_mkdir_mode wrapper can't be used anymore and
> this is no way to reuse proc_create_data due to nlinks assignment. So,
> copy the code from proc_mkdir and assign PDE->data at the appropriate
> moment.
> 
> Signed-off-by: Denis V. Lunev <den@openvz.org>

Oh well, the cost of correctness sometimes :-)

Applied, thanks.
