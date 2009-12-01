Return-Path: <linux-kernel-owner+w=401wt.eu-S1753737AbZLAIql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbZLAIql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 03:46:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbZLAIql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 03:46:41 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:58443 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbZLAIqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 03:46:40 -0500
Date: Tue, 1 Dec 2009 14:16:42 +0530
From: Sripathi Kodi <sripathik@in.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Darren Hart <dvhltc@us.ibm.com>, sripathik@in.ibm.com
Subject: [RFC] [PATCH 0/2] Futex fault injection
Message-ID: <20091201141642.398e7b7d@sripathi>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch set adds fault injection for futex subsystem. It adds faults at 
places where reading/writing from user space can return EFAULT. This will
be useful in testing any significant change to futex subsystem.

Thanks,
Sripathi.
