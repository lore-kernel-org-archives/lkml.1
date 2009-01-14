Return-Path: <linux-kernel-owner+w=401wt.eu-S1760235AbZANVcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760235AbZANVcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 16:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755395AbZANVcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 16:32:10 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59292 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753454AbZANVcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 16:32:09 -0500
Subject: Question about do_wp_page() and lock_page()
From: Larry Woodman <lwoodman@redhat.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Wed, 14 Jan 2009 16:35:08 -0500
Message-Id: <1231968908.3198.17.camel@dhcp-100-19-198.bos.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why is it safe for do_wp_page() to call cow_user_page() without locking
the old_page first?  If a Direct IO read is outstanding on the old_page
or its the buffer to the file_read_actor() cant its contents change
during the COW fault?  Is this not a problem?

Larry Woodman


