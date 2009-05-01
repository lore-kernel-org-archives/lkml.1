Return-Path: <linux-kernel-owner+w=401wt.eu-S1764951AbZEAO66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764951AbZEAO66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 10:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932280AbZEAOq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 10:46:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52900 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763041AbZEAOq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 10:46:27 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1241135661-9147-6-git-send-email-tabbott@mit.edu>
References: <1241135661-9147-6-git-send-email-tabbott@mit.edu> <1241135661-9147-1-git-send-email-tabbott@mit.edu> <1241135661-9147-2-git-send-email-tabbott@mit.edu> <1241135661-9147-3-git-send-email-tabbott@mit.edu> <1241135661-9147-4-git-send-email-tabbott@mit.edu> <1241135661-9147-5-git-send-email-tabbott@mit.edu> 
To: Tim Abbott <tabbott@MIT.EDU>
Cc: dhowells@redhat.com, Sam Ravnborg <sam@ravnborg.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>
Subject: Re: [PATCH 5/6] mn10300: use new macros for .data.init_task.
Date: Fri, 01 May 2009 15:46:19 +0100
Message-ID: <11779.1241189179@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Abbott <tabbott@MIT.EDU> wrote:

> .data.init_task should not need a separate output section; this change
> moves it into the .data section.

Hmmm...  This causes the kernel I'm building to make an extra page of RAM into
dead space.

David
