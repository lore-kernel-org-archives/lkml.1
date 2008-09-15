Return-Path: <linux-kernel-owner+w=401wt.eu-S1756018AbYIOSAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbYIOSAG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 14:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755754AbYIOR7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 13:59:46 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:55149 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669AbYIOR7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 13:59:45 -0400
Subject: Re: [RFC v5][PATCH 2/8] General infrastructure for checkpoint
	restart
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: arnd@arndb.de, jeremy@goop.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
In-Reply-To: <1221347167-9956-3-git-send-email-orenl@cs.columbia.edu>
References: <1221347167-9956-1-git-send-email-orenl@cs.columbia.edu>
	 <1221347167-9956-3-git-send-email-orenl@cs.columbia.edu>
Content-Type: text/plain
Date: Mon, 15 Sep 2008 10:59:30 -0700
Message-Id: <1221501570.16561.9.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-09-13 at 19:06 -0400, Oren Laadan wrote:
> +/*
> + * FIXME: (temporarily added file_pos_read() and file_pos_write() because
> + * they are static in fs/read_write.c... should cleanup and remove later)
> + */
> +static inline loff_t file_pos_read(struct file *file)
> +{
> +       return file->f_pos;
> +}
> +
> +static inline void file_pos_write(struct file *file, loff_t pos)
> +{
> +       file->f_pos = pos;
> +}

It's probably time to address this fixme.  

-- Dave

