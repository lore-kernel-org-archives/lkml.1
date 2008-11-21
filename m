Return-Path: <linux-kernel-owner+w=401wt.eu-S1756677AbYKURxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677AbYKURxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 12:53:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbYKURxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 12:53:39 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:54568 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580AbYKURxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 12:53:39 -0500
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
Date: Fri, 21 Nov 2008 09:53:31 -0800
Message-Id: <1227290011.11607.43.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-20 at 11:43 -0500, Mimi Zohar wrote:
> 
> +static int integrity_audit;
> +
> +#ifdef CONFIG_INTEGRITY_AUDIT
> +static int __init integrity_audit_setup(char *str)
> +{
> +       ulong audit;
> +       int rc;
> +       char *op;
> +
> +       rc = strict_strtoul(str, 0, &audit);

I think we usually write out 'unsigned long'.

-- Dave

