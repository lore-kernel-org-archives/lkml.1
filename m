Return-Path: <linux-kernel-owner+w=401wt.eu-S1030474AbXBTV66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030474AbXBTV66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 16:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030475AbXBTV66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 16:58:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030474AbXBTV65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 16:58:57 -0500
X-Originating-IP: [172.16.81.92]
From: "Chris Snook" <csnook@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, dhowells@redhat.com, jeffpc@josefsipek.net,
       csnook@redhat.com
Subject: [PATCH 0/2] use symbolic constants in generic lseek code
Date: Tue, 20 Feb 2007 16:57:50 -0500
Message-ID: <20070220.waF.48959600@egw.corp.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
X-Mailer: AngleMail for eGroupWare (http://www.egroupware.org) v 1.2.106
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The generic lseek code in fs/read_write.c uses hardcoded values for
SEEK_{SET,CUR,END}.

Patch 1 fixes the case statements to use the symbolic constants in
include/linux/fs.h, and should not be at all controversial.

Patch 2 adds a SEEK_MAX and uses it to validate user arguments.  This makes
the code a little cleaner and also enables future extensions (such as
SEEK_DATA and SEEK_HOLE).  If anyone has a problem with this, please speak up.

-- Chris

