Return-Path: <linux-kernel-owner+w=401wt.eu-S1751582AbZIHQwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582AbZIHQwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 12:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751089AbZIHQwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 12:52:09 -0400
Received: from exprod6ob113.obsmtp.com ([64.18.1.30]:33335 "HELO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751074AbZIHQwI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 12:52:08 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: linux-next: manual merge of the mtd tree with the i2c tree
Date: Tue, 8 Sep 2009 12:52:07 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901CBE901@mi8nycmail19.Mi8.com>
In-Reply-To: <20090907133621.3b4d4ce3.sfr@canb.auug.org.au>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: linux-next: manual merge of the mtd tree with the i2c tree
Thread-Index: AcovbGNd3EazCOuTQPW8PuiP9+jIHgBOB4Mg
References: <20090907133621.3b4d4ce3.sfr@canb.auug.org.au>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>,
       "David Woodhouse" <dwmw2@infradead.org>
Cc: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Jean Delvare" <khali@linux-fr.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Artem Bityutskiy" <Artem.Bityutskiy@nokia.com>
X-OriginalArrivalTime: 08 Sep 2009 16:52:08.0457 (UTC) FILETIME=[B3E7E790:01CA30A4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, September 06, 2009 8:36 PM, Stephen Rothwell wrote:
> Hi David,
> 
> Today's linux-next merge of the mtd tree got a conflict in
> drivers/mtd/mtdcore.c between commit
> c6ce12828f9146f12d0654241bcb39523c257c90 ("driver model: constify
> attribute groups") from the i2c tree and commit
> fca910883324d437a24d447b08f524fa19261a94 ("mtd: make few symbols static")
> from the mtd tree.
> 
> Just overlapping changes.  I fixed it up (see below) and can carry the
> fix as necessary.

Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>

> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc drivers/mtd/mtdcore.c
> index 69007a6,3f559c0..0000000
> --- a/drivers/mtd/mtdcore.c
> +++ b/drivers/mtd/mtdcore.c
> @@@ -217,7 -217,7 +217,7 @@@ static struct attribute_group mtd_grou
>   	.attrs		= mtd_attrs,
>   };
>   
> - const struct attribute_group *mtd_groups[] = {
>  -static struct attribute_group *mtd_groups[] = {
> ++static const struct attribute_group *mtd_groups[] = {
>   	&mtd_group,
>   	NULL,
>   };
