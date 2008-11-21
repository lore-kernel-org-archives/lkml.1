Return-Path: <linux-kernel-owner+w=401wt.eu-S1757944AbYKURrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944AbYKURrI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 12:47:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754845AbYKURqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 12:46:55 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:39888 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039AbYKURqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 12:46:54 -0500
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
Date: Fri, 21 Nov 2008 09:46:43 -0800
Message-Id: <1227289603.11607.38.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-20 at 11:43 -0500, Mimi Zohar wrote:
> 
> +       rcu_read_lock();
> +       rc = integrity_find_template(template_name, &template_entry);
> +       if (rc == 0)
> +               tget(template_entry);
> +       rcu_read_unlock();

This little nugget is repeated over and over.  How about an
integrity_find_get_template()?

-- Dave

