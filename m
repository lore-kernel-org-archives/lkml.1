Return-Path: <linux-kernel-owner+w=401wt.eu-S1756168AbYIOSwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbYIOSwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 14:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753503AbYIOSwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 14:52:21 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:53888 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753761AbYIOSwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 14:52:20 -0400
Message-ID: <48CEAEBA.10208@linux.vnet.ibm.com>
Date: Mon, 15 Sep 2008 11:51:38 -0700
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080725)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linuxfoundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix declaration of cgroup_mm_owner_callbacks()
References: <B21AC749-D9D3-4B6C-B490-091F06F78E41@google.com>
In-Reply-To: <B21AC749-D9D3-4B6C-B490-091F06F78E41@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> +static inline void cgroup_mm_owner_callbacks(struct task_struct *old,
> +                         struct task_struct *new) {}

This is confusing coding style, I'd prefer to see the implementation after the
function declaration

Looks good to me otherwise.

-- 
	Balbir
