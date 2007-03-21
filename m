Return-Path: <linux-kernel-owner+w=401wt.eu-S932247AbXCUWId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247AbXCUWId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 18:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933855AbXCUWId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 18:08:33 -0400
Received: from smtp.osdl.org ([65.172.181.24]:55666 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932247AbXCUWIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 18:08:32 -0400
Date: Wed, 21 Mar 2007 15:07:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: divy@chelsio.com
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 2.6.21 3/4] cxgb3 - Fix potential MAC hang
Message-Id: <20070321150748.2abf2bd5.akpm@linux-foundation.org>
In-Reply-To: <20070318201011.16310.77866.stgit@localhost.localdomain>
References: <20070318201011.16310.77866.stgit@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Mar 2007 13:10:12 -0700
divy@chelsio.com wrote:

> From: Divy Le Ray <divy@chelsio.com>
> 
> Under rare conditions, the MAC might hang while generating a pause frame.
> This patch fine tunes the MAC settings to avoid the issue, allows for 
> periodic MAC state check, and triggers a recovery if hung. 
> 
> Also fix one MAC statistics counter for the rev board T3B2.

This conflicts with your previously-submitted, not-yet-merged-by-Jeff
cxgb3-add-sw-lro-support.patch.

What should we do about this?
