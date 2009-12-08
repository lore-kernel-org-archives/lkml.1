Return-Path: <linux-kernel-owner+w=401wt.eu-S965807AbZLHTHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965807AbZLHTHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 14:07:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965787AbZLHTHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 14:07:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33757 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965801AbZLHTHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 14:07:04 -0500
Date: Tue, 8 Dec 2009 11:06:42 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "David S. Miller" <davem@davemloft.net>,
       Robert Olsson <robert.olsson@its.uu.se>,
       Jens Laas <jens.laas@data.slu.se>, Hans Liss <hans.liss@its.uu.se>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fib-trie: code cleanup
Message-ID: <20091208110642.1dbb53cd@nehalam>
In-Reply-To: <20091208184839.GA31383@Krystal>
References: <20091208184839.GA31383@Krystal>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Dec 2009 13:48:39 -0500
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> -	while ( (tb_node = rcu_dereference(tb->tb_hlist.next)) ) {
> +	while ((tb_node = rcu_dereference(tb->tb_hlist.next))) {
>  

This is clearer before with the added whitespace, ignore checkpatch natterings.

-- 
