Return-Path: <linux-kernel-owner+w=401wt.eu-S1754641AbYC1Nf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbYC1Nf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 09:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbYC1NfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 09:35:18 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:11109 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbYC1NfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 09:35:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=FXMEwc8fo3y+w5k5o/46FOkmuO2jp/cGKv3akbySGIwr6HOHko3dmHD4xpe3R1MN4GQJgwKggyrMAl2POlJci11sToX1flkHxKYacR9wJ199wsaXhxTQSF4EjyKAKnUzmnR/9p6PhD20lhPUDJA+yMHI+UCFKcLHK1Kf5R+cINc=
Message-ID: <b6c5339f0803280634u1ab1b3aare58d3794dfde2af9@mail.gmail.com>
Date: Fri, 28 Mar 2008 09:34:56 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Subject: Re: [PATCH 2/7] omfs: add inode routines
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <200803280442.45974.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1206578760-9050-2-git-send-email-me@bobcopeland.com>
	 <200803280442.45974.arnd@arndb.de>
X-Google-Sender-Auth: 9bebb1caef628b86
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 11:42 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 27 March 2008, Bob Copeland wrote:
>  If you could avoid the i_state member in omfs_inode_info, you could get
>  rid of your own inode cache entirely. Your i_state seems to be mostly
>  write-only, why is it needed in your file system?

Err, yeah, it looks to be superfluous.  I think it's a relic from when
I once did an initialization in omfs_write_inode.

Thanks,
Bob
