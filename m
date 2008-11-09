Return-Path: <linux-kernel-owner+w=401wt.eu-S1755838AbYKIRnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbYKIRnD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 12:43:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755434AbYKIRmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 12:42:51 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:61981 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409AbYKIRmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 12:42:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=SRnY7gAKzB6yufeMvSiCMLR0MVaGOt779GzOZTeWspLOronlE0ejtoeU1ZivEpMeAi
         VlJ33dxs4NlqzvK8uzOTrF93KcSGCS2o6HL8EWk6becmb+CNHbvYVkDo29rj+29AAKcG
         wRMhWNji85yaGTIul8givUNc8iJDqnneKX9LI=
Message-ID: <49172112.60508@gmail.com>
Date: Sun, 09 Nov 2008 18:42:42 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: LKML <linux-kernel@vger.kernel.org>, ipw3945-devel@lists.sourceforge.net,
       reinette.chatre@intel.com, yi.zhu@intel.com,
       linux-wireless@vger.kernel.org,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: BUG: scheduling while atomic: iwl3945/0/3680/0x00000002 during
 resume from suspend
References: <20081109141412.GA5858@dhcp35.suse.cz>
In-Reply-To: <20081109141412.GA5858@dhcp35.suse.cz>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2008 03:14 PM, Michal Hocko wrote:
> Hi,

Hi,

> I have noticed BUG condition (%subj) during resume from suspend (see
> attached dmesg from the resume start) if wireless interface is up
> during suspend to RAM (BUG doesn't occure when interface is not
> configured during suspend).
> 
> Notebook seems to survive this problem without any noticeable problems
> (wifi is working).
> 
> I am using recent Linus git tree (75fa67706cce5272bcfc51ed646f2da21f3bdb6e) 
> with the config attached but the same problem occurs on the 2.6.28-rc2
> and 2.6.27 kernels too (see logs). Traces are not the same, but they are
> very similar.

I think the same as:
http://marc.info/?l=linux-wireless&m=122254514501379&w=2
