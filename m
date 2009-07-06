Return-Path: <linux-kernel-owner+w=401wt.eu-S1755560AbZGFOv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbZGFOv7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 10:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbZGFOvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 10:51:50 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:53964 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349AbZGFOvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 10:51:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=VqMLzffD5/sESGi9ca3d27KDlLPwbqU2hUT1ojLpNXUXnj2iACkAG2IYM+NJG69Pq/
         YWlhOA5KLhhzJsW6gbpn0jXvyK670vclK6Kc6jUssZBQtlsnQg514F+U2oalrlS8NGj2
         6CX9z0hg9bA2ovKm6Sl6AZGupoJ5+WVecIb/Q=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: wuzhangjin@gmail.com
Subject: Re: [Bug #13663] suspend to ram regression (IDE related)
Date: Mon, 6 Jul 2009 16:57:59 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc2-next-20090706-03300-ga0c36f0; KDE/4.2.4; i686; ; )
Cc: Jeff Chua <jeff.chua.linux@gmail.com>,
       Etienne Basset <etienne.basset@numericable.fr>,
       David Miller <davem@davemloft.net>, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-ide@vger.kernel.org
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera> <200907031508.47891.bzolnier@gmail.com> <1246635096.16890.6.camel@falcon>
In-Reply-To: <1246635096.16890.6.camel@falcon>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200907061658.00936.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 July 2009 17:31:36 Wu Zhangjin wrote:
> Hi,
> 
> > OK, I see another gotcha added by recent changes, we need to explicitly
> > initialize rq_in_flight variables now.  Revised patch below..
> > 
> 
> Sorry, STD also not work. if apply this patch, the same problem as not
> apply it, it stopped at:
> 
> ...
> PM: Crete hibernation image:
> PM: Need to copy ... pages
> PM: Hibernation image created ...
> 
> I think it's better to revert this commit:
>  a1317f714af7aed60ddc182d0122477cbe36ee9b ("ide: improve handling of
> Power Management requests")
 
I completely agree and I've already requested this a week ago
(this commit was not meant for going straight to -rc tree anyway).
