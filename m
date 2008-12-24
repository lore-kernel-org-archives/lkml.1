Return-Path: <linux-kernel-owner+w=401wt.eu-S1752051AbYLXV0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbYLXV0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 16:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbYLXV0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 16:26:40 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:58220 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbYLXV0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 16:26:40 -0500
Date: Wed, 24 Dec 2008 13:25:06 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: ebiederm@xmission.com, roland@redhat.com, bastian@waldi.eu.org,
       daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 5/7][v4] Protect cinit from blocked fatal signals
Message-ID: <20081224212506.GE13502@us.ibm.com>
References: <20081224114414.GA7879@us.ibm.com> <20081224115229.GE8020@us.ibm.com> <20081224160931.GC11593@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081224160931.GC11593@redhat.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

| Personally, I'd prefer to retain this check inline with a small
| comment
| 
| 		/* SMALL COMMENT ;) */
| 		if (unlikely(signal->flags & SIGNAL_UNKILLABLE) &&
| 		    !sig_kernel_only(signr))
| 			continue;

Ok. :-)
