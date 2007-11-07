Return-Path: <linux-kernel-owner+w=401wt.eu-S1757454AbXKGHuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454AbXKGHuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 02:50:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755904AbXKGHup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 02:50:45 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35839
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755882AbXKGHuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 02:50:44 -0500
Date: Tue, 06 Nov 2007 23:50:40 -0800 (PST)
Message-Id: <20071106.235040.15743646.davem@davemloft.net>
To: ebiederm@xmission.com
Cc: rick.jones2@hp.com, bunk@kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] always export sysctl_{r,w}mem_max
From: David Miller <davem@davemloft.net>
In-Reply-To: <m1d4v1whh5.fsf@ebiederm.dsl.xmission.com>
References: <472278E3.4000909@hp.com>
	<20071026.163958.171785530.davem@davemloft.net>
	<m1d4v1whh5.fsf@ebiederm.dsl.xmission.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 26 Oct 2007 18:04:22 -0600

> So if this is really something we want to stop doing we should
> be able to take a few extra moments remove the code from the
> two problem drivers, and remove the exports.

I've killed the references in dlm and rrunner in the net-2.6
tree.
