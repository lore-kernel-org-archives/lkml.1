Return-Path: <linux-kernel-owner+w=401wt.eu-S1754464AbYJUBoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbYJUBoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 21:44:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbYJUBnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 21:43:40 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:40106 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752074AbYJUBnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 21:43:39 -0400
Subject: [PATCH 0/3] Improve TSC as a clocksource under VMware
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Dan Hecht <dhecht@vmware.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Mon, 20 Oct 2008 18:35:02 -0700
Message-Id: <1224552902.2640.88.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch set makes some changes to the TSC code, so that it is always
used as the default clocksource when running under VMware.
The first 2 patches do the ground work of adding code to detect if we
are running under VMware.
The third patch adds a tsc_reliable flag which tells us that TSC is
reliable on this system, so that we can skip some tests which can
potentially mark TSC as unstable. Details under individual patch
headers. 

Please have a look.

Thanks,
Alok

