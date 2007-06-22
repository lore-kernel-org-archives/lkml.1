Return-Path: <linux-kernel-owner+w=401wt.eu-S1758852AbXFVWxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852AbXFVWxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 18:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbXFVWxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 18:53:12 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:2283 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbXFVWxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 18:53:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NRZCfcO6KN2f3+2fwR/fPQfoQcQ252J48BHqOZ2t/10meO1aecqgBMz9Rkhmg7Z3blD4B0SsmFSwO6FVS85tGypGJ6TM9Wz0c45c8tKj3JPp/TtyGTOhAxEMBCGaIfHUH7Ezkovn8ScJH6uY4AWkPKRy9JgY7wwiCtCcUXgBGiw=
Message-ID: <6bffcb0e0706221553s3a74ef58hcadc69bfa252283@mail.gmail.com>
Date: Sat, 23 Jun 2007 00:53:11 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Oliver Pinter" <oliver.pntr@gmail.com>
Subject: Re: [REGRESSION 2.6-git] possible circular locking dependency detected with XFS
Cc: linux-kernel <linux-kernel@vger.kernel.org>, dgc@sgi.com
In-Reply-To: <6101e8c40706221340k65f15957k39a04193cb6e7c01@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6101e8c40706221340k65f15957k39a04193cb6e7c01@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver,

On 22/06/07, Oliver Pinter <oliver.pntr@gmail.com> wrote:
> Hi all!
>
> I found this info:
>
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.22-rc5-wifi1 #2
> -------------------------------------------------------
> mount/2209 is trying to acquire lock:
>  (&(&ip->i_lock)->mr_lock/1){--..}, at: [<c022b62d>] xfs_ilock+0x66/0x90
>
> but task is already holding lock:
>  (&(&ip->i_lock)->mr_lock){----}, at: [<c022b62d>] xfs_ilock+0x66/0x90
>

AFAIR it is not a regression. It is a known bug (harmless).

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
