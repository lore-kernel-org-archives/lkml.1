Return-Path: <linux-kernel-owner+w=401wt.eu-S965111AbXBTExM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965111AbXBTExM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 23:53:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965115AbXBTExM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 23:53:12 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:38198 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965111AbXBTExM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 23:53:12 -0500
Date: Mon, 19 Feb 2007 20:53:10 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Rik van Riel <riel@redhat.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] free swap space when (re)activating page
In-Reply-To: <45D63445.5070005@redhat.com>
Message-ID: <Pine.LNX.4.64.0702192048150.9934@schroedinger.engr.sgi.com>
References: <45D63445.5070005@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Feb 2007, Rik van Riel wrote:

> What do you think?

Looks good apart from one passage (which just vanished when I tried to 
reply, please post patches as inline text).

It was the portion that modifies shrink_active_list. Why operate
on the pagevec there? The pagevec only contains the leftovers to be 
released from scanning over the temporary inactive list.

