Return-Path: <linux-kernel-owner+w=401wt.eu-S1756545AbZBWS37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545AbZBWS37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 13:29:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753647AbZBWS3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 13:29:51 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47389 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367AbZBWS3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 13:29:50 -0500
Date: Mon, 23 Feb 2009 19:26:38 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] forget_original_parent: split out the un-ptrace
	part
Message-ID: <20090223182638.GA22806@redhat.com>
References: <20090211211216.GA16847@redhat.com> <20090220022746.8852CFC2F7@magilla.sf.frob.com> <20090223164632.GA16294@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090223164632.GA16294@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23, Oleg Nesterov wrote:
>
> If we are going to optimize out tasklist in forget_original_parent(), then
> I'd prefer http://marc.info/?l=linux-kernel&m=123438710725342
>
> But this needs a fat comment. And I didn't think carefully about this code.

No, this won't work.

When ->child_reaper exits, it must take tasklist and call find_new_reaper()
even if it has no children.

Oleg.

