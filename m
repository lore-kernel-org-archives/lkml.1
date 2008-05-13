Return-Path: <linux-kernel-owner+w=401wt.eu-S1761072AbYEMUJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761072AbYEMUJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758861AbYEMUJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:09:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46266 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758057AbYEMUJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:09:18 -0400
Date: Tue, 13 May 2008 13:08:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: menage@google.com
Cc: pj@sgi.com, xemul@openvz.org, balbir@in.ibm.com, serue@us.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [RFC/PATCH 3/8]: CGroup Files: Move the release_agent file to
 use typed handlers
Message-Id: <20080513130833.cc03caea.akpm@linux-foundation.org>
In-Reply-To: <20080513071522.470099000@menage.corp.google.com>
References: <20080513063707.049448000@menage.corp.google.com>
	<20080513071522.470099000@menage.corp.google.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2008 23:37:10 -0700
menage@google.com wrote:

> +		agentbuf = kmalloc(PATH_MAX, GFP_KERNEL);
> +		if (!agentbuf)
> +			goto continue_free;
> +		strcpy(agentbuf, cgrp->root->release_agent_path);

Did we need to allocate all that memory, or would kstrdup() suffice?
