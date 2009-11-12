Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbZKLWdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbZKLWdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 17:33:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754579AbZKLWda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 17:33:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38380 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754547AbZKLWd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 17:33:29 -0500
Date: Thu, 12 Nov 2009 14:33:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: hpa@zytor.com, rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/4] Add support for LZO-compressed kernels
Message-Id: <20091112143323.6b80ca4e.akpm@linux-foundation.org>
In-Reply-To: <1257942478-18719-2-git-send-email-albin.tonnerre@free-electrons.com>
References: <1257942478-18719-1-git-send-email-albin.tonnerre@free-electrons.com>
	<1257942478-18719-2-git-send-email-albin.tonnerre@free-electrons.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Nov 2009 13:27:55 +0100
Albin Tonnerre <albin.tonnerre@free-electrons.com> wrote:

> +STATIC inline int INIT unlzo(u8 *input, int in_len,

I assume the macro gunk is to support testing of the code in a
userspace test haress?

Where does INIT get defined?
