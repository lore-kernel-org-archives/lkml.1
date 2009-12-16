Return-Path: <linux-kernel-owner+w=401wt.eu-S1762548AbZLPRWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762548AbZLPRWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 12:22:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762322AbZLPRV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 12:21:59 -0500
Received: from c60.cesmail.net ([216.154.195.49]:60423 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753871AbZLPRV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 12:21:58 -0500
Subject: Re: [PATCH] iwmc3200wifi: Fix test of unsigned in
 iwm_ntf_stop_resume_tx()
From: Pavel Roskin <proski@gnu.org>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Samuel Ortiz <samuel.ortiz@intel.com>, Zhu Yi <yi.zhu@intel.com>,
       Intel Linux Wireless <ilw@linux.intel.com>,
       linux-wireless@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B290462.7070401@gmail.com>
References: <4B28DBB6.5030304@gmail.com> <1260975195.2965.3.camel@ct>
	 <4B290462.7070401@gmail.com>
Content-Type: text/plain
Date: Wed, 16 Dec 2009 12:21:40 -0500
Message-Id: <1260984100.5725.3.camel@mj>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-16 at 17:01 +0100, Roel Kluin wrote:

> Ok, how about:

> -u16 iwm_tid_to_queue(u16 tid)
> +int iwm_tid_to_queue(u16 tid)

That's much better!  Thanks!

Reviewed-by: Pavel Roskin <proski@gnu.org>

-- 
Regards,
Pavel Roskin
