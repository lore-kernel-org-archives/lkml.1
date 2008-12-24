Return-Path: <linux-kernel-owner+w=401wt.eu-S1751890AbYLXVNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbYLXVNV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 16:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbYLXVNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 16:13:13 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:54567 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbYLXVNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 16:13:12 -0500
Date: Wed, 24 Dec 2008 13:11:37 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: ebiederm@xmission.com, roland@redhat.com, bastian@waldi.eu.org,
       daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/7][v4] Protect init from unwanted signals more
Message-ID: <20081224211137.GC13502@us.ibm.com>
References: <20081224114414.GA7879@us.ibm.com> <20081224115047.GB8020@us.ibm.com> <20081224163503.GF11593@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081224163503.GF11593@redhat.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov [oleg@redhat.com] wrote:
| Or, we can do
| 
| 	if (unlikely(t->signal->flags & SIGNAL_UNKILLABLE) &&
| 			 handler == SIG_DFL)
| 		return 1;
| 	return sig_handler_ignored(handler, sig);
| 
| because sig_handler_ignored() checks SIG_IGN too.

Yes it more optimal. I will change.
