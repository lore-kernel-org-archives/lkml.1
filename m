Return-Path: <linux-kernel-owner+w=401wt.eu-S1758551AbZDRP5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551AbZDRP5Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 11:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755951AbZDRP5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 11:57:16 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:39110 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755225AbZDRP5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 11:57:15 -0400
Subject: Re: +
 mtd-mtd-in-mtd_release-is-unused-without-config_mtd_char.patch added to -mm
 tree
From: "Denis V. Lunev" <den@openvz.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090418152635.125D.A69D9226@jp.fujitsu.com>
References: <200904150009.n3F095J1011993@imap1.linux-foundation.org>
	 <20090418152635.125D.A69D9226@jp.fujitsu.com>
Content-Type: text/plain
Organization: OpenVz kernel team
Date: Sat, 18 Apr 2009 19:56:35 +0400
Message-Id: <1240070195.29546.3.camel@iris.sw.ru>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

already fixed by Andrew by 
  mtd-mtd-in-mtd_release-is-unused-without-config_mtd_char-fix

> ------------------------------------------------------
> Subject: mtd-mtd-in-mtd_release-is-unused-without-config_mtd_char-fix
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Denis V. Lunev <den@openvz.org>
> Cc: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/mtd/mtdcore.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -puN
drivers/mtd/mtdcore.c~mtd-mtd-in-mtd_release-is-unused-without-config_mtd_char-fix drivers/mtd/mtdcore.c
> ---
a/drivers/mtd/mtdcore.c~mtd-mtd-in-mtd_release-is-unused-without-config_mtd_char-fix
> +++ a/drivers/mtd/mtdcore.c
> @@ -48,7 +48,7 @@ static LIST_HEAD(mtd_notifiers);
>   */
>  static void mtd_release(struct device *dev)
>  {
> -     dev_t index = MTD_DEVT(dev_to_mtd(dev));
> +     dev_t index = MTD_DEVT(dev_to_mtd(dev)->index);
>  
>       /* remove /dev/mtdXro node if needed */
>       if (index)

