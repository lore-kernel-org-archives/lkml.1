Return-Path: <linux-kernel-owner+w=401wt.eu-S1760357AbYFMPqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760357AbYFMPqH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 11:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756523AbYFMPp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 11:45:56 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:48802 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756489AbYFMPpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 11:45:55 -0400
Date: Fri, 13 Jun 2008 08:44:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Henne <henne@nachtwindheim.de>
Cc: eparis@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] audit:  kerneldoc fix for sessionid
Message-Id: <20080613084455.6c390216.randy.dunlap@oracle.com>
In-Reply-To: <48525074.9020907@nachtwindheim.de>
References: <48525074.9020907@nachtwindheim.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2008 12:48:20 +0200 Henne wrote:

> Add sessionid kerneldoc to auditfilter.
> 
> Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>

Ack, since I sent a similar patch on 2008-MAY-19.


> ---
> 
> diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
> index 0e0bd27..e49c2d7 100644
> --- a/kernel/auditfilter.c
> +++ b/kernel/auditfilter.c
> @@ -1544,6 +1544,7 @@ static void audit_log_rule_change(uid_t loginuid, u32 sessionid, u32 sid,
>   * @data: payload data
>   * @datasz: size of payload data
>   * @loginuid: loginuid of sender
> + * @sessionid: sessionid of sender
>   * @sid: SE Linux Security ID of sender
>   */
>  int audit_receive_filter(int type, int pid, int uid, int seq, void *data,



---
~Randy
'"Daemon' is an old piece of jargon from the UNIX operating system,
where it referred to a piece of low-level utility software, a
fundamental part of the operating system."
