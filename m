Return-Path: <linux-kernel-owner+w=401wt.eu-S1758233AbYAAXq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233AbYAAXq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 18:46:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921AbYAAXqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 18:46:21 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:7588 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857AbYAAXqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 18:46:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Di3iM5xr63uxMRgqiotZJhI8SiUcGgz24aZX6+nDiC7/p8O2x0nbf+C2P1qJfIa3N2zvFfOEOdkCNu658ASW0vCRJRG7aUi5GFjplTU5QYgHqp2qWxQCTXpZOqcVEnoCdQeMx9v1TbV6QH0pdDD8qextLqgYCiDUnzQdrawdDmI=
Message-ID: <524f69650801011546r292daedau3eb87dd6cb1ba265@mail.gmail.com>
Date: Tue, 1 Jan 2008 17:46:19 -0600
From: "Steve French" <smfrench@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: [2.6 patch] CIFS: #if 0 mode_to_access_flags()
Cc: "Adrian Bunk" <bunk@kernel.org>, sfrench@samba.org,
       linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080101181030.GA25656@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080101134644.GE2360@does.not.exist>
	 <20080101181030.GA25656@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cifsacl code which uses that function was not ready in time for
2.6.24 but is in the cifs development tree now..

On Jan 1, 2008 12:10 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Jan 01, 2008 at 03:46:44PM +0200, Adrian Bunk wrote:
> > This patch #if 0's the unused mode_to_access_flags(), fixing the
> > following compile warning:
>
> Please remove it completely instead.
>



-- 
Thanks,

Steve
