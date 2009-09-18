Return-Path: <linux-kernel-owner+w=401wt.eu-S1754615AbZIRPJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbZIRPJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 11:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbZIRPJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 11:09:37 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:33675 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983AbZIRPJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 11:09:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cAKx4mJBgIYK9KRYXfhhxk6Pjl3KKwGhs9ZYmxUFeNordYdfD8u9wN8PA7K5kxlZHG
         4sw15GnULnucIuA7w/GDNRfRZk35aF13sjkctfiQ+UjgR9I6D0skof7Cu5FYcayN6osx
         Hm+/Mrs7FiAVrnHa1+pAdTAA8uK3xSGGtPoyw=
Date: Fri, 18 Sep 2009 17:09:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tracing/events: use list_for_entry_continue
Message-ID: <20090918150930.GB5200@nowhere>
References: <4AB32364.7020602@cn.fujitsu.com> <4AB32389.1030005@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB32389.1030005@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 02:07:05PM +0800, Li Zefan wrote:
> Simplify s_next() and t_next().
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---




Nice.
I wonder if that can be even more simplified with
the following existing seq helpers:

extern struct list_head *seq_list_start(struct list_head *head,
		loff_t pos);
extern struct list_head *seq_list_start_head(struct list_head *head,
		loff_t pos);
extern struct list_head *seq_list_next(void *v, struct list_head *head,
		loff_t *ppos);


That said, it's already a nice cleanup.

