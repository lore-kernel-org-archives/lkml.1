Return-Path: <linux-kernel-owner+w=401wt.eu-S1757414AbYKURpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414AbYKURpp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 12:45:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbYKURpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 12:45:36 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:55449 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887AbYKURpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 12:45:35 -0500
Subject: Re: [PATCH 2/4] integrity: Linux Integrity Module(LIM)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@liux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <ece5bb6863d9b42016860f3ef78656e4a228ad95.1227137423.git.zohar@linux.vnet.ibm.com>
References: <cover.1227137423.git.zohar@linux.vnet.ibm.com>
	 <ece5bb6863d9b42016860f3ef78656e4a228ad95.1227137423.git.zohar@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Fri, 21 Nov 2008 09:45:18 -0800
Message-Id: <1227289518.11607.36.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-20 at 11:43 -0500, Mimi Zohar wrote:
> 
> +int integrity_find_template(const char *template_name,
> +                           struct template_list_entry **template_entry)
> +{
> +       struct template_list_entry *entry;
> +
> +       list_for_each_entry_rcu(entry, &integrity_templates, template)
> {
> +               if (strncmp(entry->template_name, template_name,
> +                           strlen(entry->template_name)) == 0) {
> +                       *template_entry = entry;
> +                       return 0;
> +               }
> +       }
> +       return -EINVAL;
> +}
> +EXPORT_SYMBOL_GPL(integrity_find_template);

Is this an appropriate place for an ERR_PTR() to get used?

-- Dave

