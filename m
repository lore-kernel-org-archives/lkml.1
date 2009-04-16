Return-Path: <linux-kernel-owner+w=401wt.eu-S1758158AbZDPQTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158AbZDPQTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 12:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755259AbZDPQT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 12:19:26 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:61158 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837AbZDPQTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 12:19:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PL9F/NY96p2jd4dI2iJluZri7drbFW9b7Nx8dyDQ5/OjZgqLYlZoT5/t0+nLDbdHR+
         3/BrqS71Wh3spKGuwdsY7nheu6PqnffmdJ7+Km76snJweUYSkRG7jPh4bU1Y3hdqMY1y
         XJh/0R2an7ZjMDykR50AfsTQgzt2rtNd5d1mM=
Date: Thu, 16 Apr 2009 18:19:21 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC][PATCH 1/2] tracing/events: provide string with undefined
	size support
Message-ID: <20090416161920.GI6004@nowhere>
References: <1239838050-8567-1-git-send-email-fweisbec@gmail.com> <49E68635.8050404@cn.fujitsu.com> <20090416074250.GB6021@nowhere> <49E6E439.1090607@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E6E439.1090607@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 03:54:33PM +0800, Li Zefan wrote:
> >>> +	entry	= ring_buffer_event_data(event);			       \
> >> small nits, below is better since we have only one assignment:
> >>
> >> 	entry = ring_buffer_event_data(event);
> > 
> > 
> > 
> > Hm, I don't understand what you are suggesting.
> > 
> 
> I meant just add a ' ' before '=' instead of a tab:
> 
> entry = ring_buffer_event_data(event);
> entry	= ring_buffer_event_data(event);
> 
> since we don't need to align with other assignment statement.
> 
> but this is just a trivial issue. :)


Ah ok :)
Will fix it (unless I remove this part to address Steven's comment.

Thanks.

 
> --
> Zefan

