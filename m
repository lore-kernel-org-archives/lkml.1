Return-Path: <linux-kernel-owner+w=401wt.eu-S932651AbZLNWwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651AbZLNWwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:52:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932303AbZLNWw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:52:29 -0500
Received: from mail-gx0-f211.google.com ([209.85.217.211]:51943 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259AbZLNWw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:52:27 -0500
X-Greylist: delayed 449 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Dec 2009 17:52:27 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=xD8vWfsqIsaAMdTIPuROTjdUuFu+L4uf7IQka2RTmCxtwdV298a0NsQiVVtF1Ehyd+
         wUlLenTEtHAr+Sf1JvAhyNkULKmnNx3mZePNfzS+eOiK3u+T9jipib0dzZoo32SXgjqx
         b/17EUMvBUGcITs6p5XkR18EQ1/NOv7BSHRQM=
Date: Tue, 15 Dec 2009 07:46:50 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>, lwoodman@redhat.com,
       akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, minchan.kim@gmail.com
Subject: Re: [PATCH 3/8] Don't use sleep_on()
Message-Id: <20091215074650.8fc2e6b5.minchan.kim@barrios-desktop>
In-Reply-To: <20091214212449.BBB7.A69D9226@jp.fujitsu.com>
References: <20091211164651.036f5340@annuminas.surriel.com>
	<20091214210823.BBAE.A69D9226@jp.fujitsu.com>
	<20091214212449.BBB7.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Dec 2009 21:29:28 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> sleep_on() is SMP and/or kernel preemption unsafe. This patch
> replace it with safe code.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviwed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
