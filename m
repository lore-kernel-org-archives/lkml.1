Return-Path: <linux-kernel-owner+w=401wt.eu-S1758235AbYFLSqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235AbYFLSqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 14:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754035AbYFLSpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 14:45:54 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:17647 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbYFLSpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 14:45:53 -0400
Date: Thu, 12 Jun 2008 11:45:45 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/3] configfs: call drop_link() to cleanup after
	create_link() failure
Message-ID: <20080612184545.GD5377@mail.oracle.com>
Mail-Followup-To: Louis Rilling <Louis.Rilling@kerlabs.com>,
	ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
References: <20080612152645.445504681@kerlabs.com> <20080612152953.667564205@kerlabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080612152953.667564205@kerlabs.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 05:26:47PM +0200, Louis Rilling wrote:
> When allow_link() succeeds but create_link() fails, the subsystem is not
> informed of the failure.
> 
> This patch fixes this by calling drop_link() on create_link() failures.
> 
> Signed-off-by: Louis Rilling <Louis.Rilling@kerlabs.com>

This looks good.

Joel

-- 

"Friends may come and go, but enemies accumulate." 
        - Thomas Jones

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
