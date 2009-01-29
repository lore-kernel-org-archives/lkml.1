Return-Path: <linux-kernel-owner+w=401wt.eu-S1757351AbZA2LrD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351AbZA2LrD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 06:47:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbZA2Lqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 06:46:51 -0500
Received: from gw-ca.panasas.com ([66.104.249.162]:4358 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751988AbZA2Lqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 06:46:50 -0500
Message-ID: <4981972A.2090801@panasas.com>
Date: Thu, 29 Jan 2009 13:46:50 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/4] [Linux/SCSI]: Change RECEIVE_CREDENTIAL to	VLC_SA_RECEIVE_CREDENTIAL
References: <1233093749.6442.97.camel@haakon2.linux-iscsi.org> <1233094236.6442.110.camel@haakon2.linux-iscsi.org>
In-Reply-To: <1233094236.6442.110.camel@haakon2.linux-iscsi.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Jan 2009 11:46:48.0864 (UTC) FILETIME=[44DF5A00:01C98207]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicholas A. Bellinger wrote:
> Hi James,
> 
> Let me know if you need a fresh respin of this patch..  According to
> spc4r17 section D.3.5, VLC_SA_RECEIVE_CREDENTIAL is the only
> VARIABLE_LENGTH_CMD defined Service ACtion..
> 
> --nab

Not accurate. See file include/scsi/osd_protocol.h in the scsi-misc
git-tree master branch. The complete OSD command set is VARIABLE_LENGTH_CMD
based. There must be others as well

Boaz
