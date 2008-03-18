Return-Path: <linux-kernel-owner+w=401wt.eu-S1752722AbYCRLF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbYCRLF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 07:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbYCRLFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 07:05:17 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:13262 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbYCRLFP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 07:05:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PKCChmQ/L43tactsx5BiSUUN5dtavhn42HxT3EQPPc0e7cOBeuxBXGHTQJCDA0AR+7ubCdBGsIiJdXqFoCxKFgdph0zNSXpD+3/QEChMkZk9AjAXowI7uRoEW69hHcfd2ZYuyDByLRqmhFhUvs++YSmatTtq5wl0slqPghUXrDA=
Message-ID: <9ea470500803180405h5ede15eaqa86515058a632e2b@mail.gmail.com>
Date: Tue, 18 Mar 2008 12:05:14 +0100
From: "Boris Petkov" <petkovbb@googlemail.com>
Reply-To: petkovbb@gmail.com
To: "Nikanth Karthikesan" <knikanth@suse.de>
Subject: Re: ide_cd modifies hard_* members of request
Cc: "Jens Axboe" <jens.axboe@oracle.com>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <1205830486.7126.16.camel@nikanth-laptop.blr.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1205830486.7126.16.camel@nikanth-laptop.blr.novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(sorry, forgot to cc all)

On Tue, Mar 18, 2008 at 9:54 AM, Nikanth Karthikesan <knikanth@suse.de> wrote:
> Hi
>
>  Despite the warning in blkdev.h, that members of struct request starting
>  with hard_* are block layer internals, and no driver should touch them,
>  the ide_cd driver seems to fiddle around with it.
>
>  Is this reqd, or can this be made to work without the need for this?
>
>  If this reqd, why not provide a helper function for that in block layer
>  itself, may be, with a warning about usage?
>
>  Thanks
>  Nikanth Karthikesan

Hi,

the code pieces you're referring to are in there since at least the
first git import of the kernel source (i.e. 2005) aka long time so
Bart/Jens should know that...


-- 
Regards/Gruﬂ,
Boris
