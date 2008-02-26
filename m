Return-Path: <linux-kernel-owner+w=401wt.eu-S1761658AbYBZJK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761658AbYBZJK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 04:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756388AbYBZJKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 04:10:13 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:38403 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756350AbYBZJKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 04:10:11 -0500
Date: Tue, 26 Feb 2008 12:09:53 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: linux-kernel@vger.kernel.org
Cc: sds@tycho.nsa.gov, jmorris@namei.org, eparis@parisplace.org,
       casey@schaufler-ca.com
Subject: SMACK or SELinux, but not both
Message-ID: <20080226090953.GA7469@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If SELinux is registered before SMACK, SMACK panics after
register_security() call.

If SMACK is registered before SELinux, SELinux panics after
register_security() call.

Consequently allmodconfig kernel doesn't boot. It would be nice if
some Kconfig magic to exclude each other will be in place.

