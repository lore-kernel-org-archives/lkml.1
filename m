Return-Path: <linux-kernel-owner+w=401wt.eu-S1754370AbXEDMfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370AbXEDMfO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 08:35:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754379AbXEDMfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 08:35:14 -0400
Received: from oker.escape.de ([194.120.234.254]:36693 "EHLO oker.escape.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754243AbXEDMfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 08:35:08 -0400
To: linux-kernel@vger.kernel.org
Subject: Q: copy_*_user() with size==0
From: Urs Thuermann <urs@isnogud.escape.de>
Date: 04 May 2007 14:32:59 +0200
Message-ID: <ygfr6pwydj8.fsf@janus.isnogud.escape.de>
User-Agent: Gnus/5.0808 (Gnus v5.8.8) Emacs/20.7
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Reading the i386 source of copy_to_user() and reading some instances
of how it's used, it seems valid to pass 0 for the size argument and
that kernel address pointers, i.e. the @from argument in
copy_to_user() and the @to argument in copy_from_user() don't matter
in this case.  Is this correct for all arch's?  I don't see this
behavior documented anywhere.

urs
