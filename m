Return-Path: <linux-kernel-owner+w=401wt.eu-S1757813AbZKRQmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757813AbZKRQmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 11:42:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757641AbZKRQme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 11:42:34 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:41562 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757624AbZKRQme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 11:42:34 -0500
To: <linux-kernel@vger.kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 0/3] misc sysctl cleanups
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 18 Nov 2009 08:42:37 -0800
Message-ID: <m1d43fbx8i.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When looking over my sysctl changes I have found a few more obvious
cleanups I can make.  The big change is removing & from in front of
every .proc_handler definition.  My sysctl tree is already touching
all of the sysctl definitions anyway so I might as well make this
cleanup now.

Eric W. Biederman (3):
      sysctl: kill dead ctl_handler definitions.
      sysctl: Remove CTL_NONE and CTL_UNNUMBERED
      sysctl: Drop & in front of every proc_handler.

