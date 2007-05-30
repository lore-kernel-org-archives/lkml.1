Return-Path: <linux-kernel-owner+w=401wt.eu-S1758273AbXE3Ust@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273AbXE3Ust (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 16:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbXE3Usm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 16:48:42 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:21685 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbXE3Usl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 16:48:41 -0400
X-IronPort-AV: i="4.14,594,1170662400"; 
   d="scan'208"; a="3352668:sNHT674397972"
To: openib-general@openib.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [ofa-general] [PATCH] drivers/infiniband: fix comparsion between unsigned and negative
X-Message-Flag: Warning: May contain useful information
References: <20070530080518.GA29195@nostromo.devel.redhat.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 30 May 2007 13:48:29 -0700
In-Reply-To: <20070530080518.GA29195@nostromo.devel.redhat.com> (Bill Nottingham's message of "Wed, 30 May 2007 04:05:18 -0400")
Message-ID: <adairaaqbqa.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 May 2007 20:48:30.0207 (UTC) FILETIME=[E13338F0:01C7A2FB]
Authentication-Results: sj-dkim-5; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim5002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I just went through this patch, and all the changes are of the form of
removing the < 0 test from code like

	if (x < 0 || x > MAX) 
		return -ERROR;

which Linus said we don't change in the email <http://lkml.org/lkml/2006/11/28/206>
that Satyam just pointed out.  So I'll drop this patch.

 - R.
