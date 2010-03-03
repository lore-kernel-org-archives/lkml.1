Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab0CCDDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 22:03:47 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:42405 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab0CCDDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 22:03:45 -0500
Date: Wed, 3 Mar 2010 12:03:08 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Steven J. Magnani" <steve@digidescorp.com>
Cc: David Howells <dhowells@redhat.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nommu: get_user_pages(): pin last page on non-page-aligned start
Message-ID: <20100303030308.GA29025@linux-sh.org>
References: <1267554584-24349-1-git-send-email-steve@digidescorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267554584-24349-1-git-send-email-steve@digidescorp.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02, 2010 at 12:29:44PM -0600, Steven J. Magnani wrote:
> The noMMU version of get_user_pages() fails to pin the last page
> when the start address isn't page-aligned. The patch fixes this in a way
> that makes find_extend_vma() congruent to its MMU cousin.
> 
> Signed-off-by: Steven J. Magnani <steve@digidescorp.com>

Looks good to me.  David?

Acked-by: Paul Mundt <lethal@linux-sh.org>
