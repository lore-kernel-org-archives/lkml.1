Return-Path: <linux-kernel-owner+w=401wt.eu-S1755616AbZJ2AJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616AbZJ2AJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 20:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbZJ2AJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 20:09:50 -0400
Received: from smtp.microsoft.com ([131.107.115.212]:23898 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323AbZJ2AJt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 20:09:49 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: Milan Dadok <milan@dadok.name>, "'Greg Kroah-Hartman'" <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Haiyang Zhang" <haiyangz@microsoft.com>
Subject: RE: [PATCH] 2/3 staging: hv: fix oops in vmbus - netvsc list_head
Thread-Topic: [PATCH] 2/3 staging: hv: fix oops in vmbus - netvsc list_head
Thread-Index: AcpYHUsWpndeDo9YTDGqhyDth2lMgAADmdyg
Date: Thu, 29 Oct 2009 00:09:51 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C5620E7EEC42@TK5EX14MBXC114.redmond.corp.microsoft.com>
References: <001501ca581d$4c201fb0$e4605f10$@name>
In-Reply-To: <001501ca581d$4c201fb0$e4605f10$@name>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>Remove incorrect list_head usage. Variable of type list_head was used in
>some function's arguments as list item.

Milan,

I just checked this patch and thanks a million, this corrects the kernel crashing
When loading hv_netvsc :)

We have been working on fixing this issue for the last day or so, and you 
Beat us to it! Excellent!

It looks like you might already have one, but if you need a license for 
Server 2008/R2 to play with for this code, please let me know and I will
Send you one!

Thank you very much!

Hank.

