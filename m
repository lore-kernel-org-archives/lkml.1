Return-Path: <linux-kernel-owner+w=401wt.eu-S1758898AbYLDPne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898AbYLDPne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 10:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758359AbYLDPl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 10:41:29 -0500
Received: from rn-out-0910.google.com ([64.233.170.190]:61079 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758341AbYLDPl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 10:41:28 -0500
Date: Thu, 4 Dec 2008 16:41:20 +0100
From: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [W1] Added list masters w1 command.
Message-ID: <20081204154120.GB4864@gambetta>
References: <12284022104086-git-send-email-zbr@ioremap.net> <122840221468-git-send-email-zbr@ioremap.net> <12284022143564-git-send-email-zbr@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12284022143564-git-send-email-zbr@ioremap.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Evgeniy,

On Thu, Dec 04, 2008 at 05:50:06PM +0300, Evgeniy Polyakov wrote:
> +	mutex_lock(&w1_mlock);
> +	list_for_each_entry(m, &w1_masters, w1_master_entry) {
> +		if (cn->len + sizeof(*id) > PAGE_SIZE - sizeof(struct cn_msg)) {
> +			cn_netlink_send(cn, 0, GFP_KERNEL);
> +			cn->ack++
			^^^^^^^^^^
';' is missing here

Regards,
Frederik
