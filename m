Return-Path: <linux-kernel-owner+w=401wt.eu-S1752637AbZIYHgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbZIYHgf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 03:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbZIYHge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 03:36:34 -0400
Received: from avexch1.qlogic.com ([198.70.193.115]:9133 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbZIYHgd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 03:36:33 -0400
From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
To: Jiri Slaby <jirislaby@gmail.com>
CC: "James.Bottomley@suse.de" <James.Bottomley@suse.de>,
       "linux-scsi@vger.kernel.org Mailing List" 
	<linux-scsi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Vasquez <andrew.vasquez@qlogic.com>
Date: Fri, 25 Sep 2009 00:36:36 -0700
Subject: Re: [PATCH 4/5] SCSI: qla2xxx, fix NULL-ptr dereference
Thread-Topic: [PATCH 4/5] SCSI: qla2xxx, fix NULL-ptr dereference
Thread-Index: Aco9stJPAfbeUvsrSZGZ0+ehyx/eTw==
Message-ID: <3B8522E6-D391-4057-9F9D-84FC1019B337@qlogic.com>
References: <1253715335-6723-1-git-send-email-jirislaby@gmail.com>
 <1253715335-6723-4-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1253715335-6723-4-git-send-email-jirislaby@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 25 Sep 2009 07:35:58.0220 (UTC) FILETIME=[D2B794C0:01CA3DB2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 23, 2009, at 7:15 AM, Jiri Slaby wrote:

> Stanse found a NULL-ptr dereference on one fail path in
> qla25xx_create_rsp_que. It jumps to que_failed label and
> qla25xx_free_rsp_que there dereferences rsp which is NULL.
>
> Return with ENOMEM directly instead.
>
Thanks for pointing it out. There is another code path (create_req_que)
where the same bug exists. I will send a patch that takes care of the  
both.

-Anirban
