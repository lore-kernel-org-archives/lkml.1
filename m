Return-Path: <linux-kernel-owner+w=401wt.eu-S1762979AbXJZB4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762979AbXJZB4K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 21:56:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756649AbXJZBz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 21:55:56 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38171 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758161AbXJZBzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 21:55:55 -0400
Date: Thu, 25 Oct 2007 18:55:53 -0700
From: Paul Jackson <pj@sgi.com>
To: Paul Menage <menage@google.com>
Cc: akpm@linux-foundation.org, vatsa@in.ibm.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Move cgroups destroy() callbacks to cgroup_diput()
Message-Id: <20071025185553.97d92749.pj@sgi.com>
In-Reply-To: <472146C8.7060709@google.com>
References: <472146C8.7060709@google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul M wrote:
> -LL=cgroup_mutex
> +(cgroup_mutex held by caller)

Thanks.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
