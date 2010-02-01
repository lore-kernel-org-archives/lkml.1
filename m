Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab0BAP0t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 10:26:49 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:54809 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084Ab0BAP0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 10:26:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kYJ6nYOi71DR5LTskgYdKKhCHPwqi5ve/8oTB6p8fv/gl72SjV4bFcYLOeWDUcXzdo
         i7FXhzjkO2vLV0RcNCsWI2gdXxr2IhgseeYKzLtLmjOJAzY8agIlzVk4cg9ynXin8MiX
         VCJOiRy6+pnrFsZkUUzjSgYbSp2U0Lij9dIJg=
Subject: Re: [PATCH -mm] rmap: remove obsolete check from
 __page_check_anon_rmap
From: Minchan Kim <minchan.kim@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, lwoodman@redhat.com,
       akpm@linux-foundation.org, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       aarcange@redhat.com
In-Reply-To: <20100128014312.47c5045d@annuminas.surriel.com>
References: <20100128002000.2bf5e365@annuminas.surriel.com>
	 <20100128014312.47c5045d@annuminas.surriel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Feb 2010 00:26:39 +0900
Message-ID: <1265037999.20322.33.camel@barrios-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-28 at 01:43 -0500, Rik van Riel wrote:
> When an anonymous page is inherited from a parent process, the
> vma->anon_vma can differ from the page anon_vma.  This can trip
> up __page_check_anon_rmap, which is indirectly called from
> do_swap_page().
> 
> Remove that obsolete check to prevent an oops.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim>

Hmm, too late. 

-- 
Kind regards,
Minchan Kim


