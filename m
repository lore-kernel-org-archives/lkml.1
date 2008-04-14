Return-Path: <linux-kernel-owner+w=401wt.eu-S1762640AbYDNRTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762640AbYDNRTU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 13:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756498AbYDNRTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 13:19:08 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:7270 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbYDNRTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 13:19:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=MguxPG/eQR9ddilLjDcklKBrVSJphlasDam6NdzSuSVHDTJA/7HL7GxueBnzGD9Lqx29ZnJs4DvSKaAEseU2BkdnEvmtu42MiVixRTVOus9SDK2PjsbO5vAWESqMNQ/a0kPbG878c8z3fhYZ7EwPQKpSgUZFEhoGID4GHeqwlFY=
Message-ID: <b6c5339f0804141018k100b6f68ob57b35a67c669e9c@mail.gmail.com>
Date: Mon, 14 Apr 2008 13:18:53 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Cc: "Christoph Hellwig" <hch@infradead.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "David Woodhouse" <dwmw2@infradead.org>,
       "Miklos Szeredi" <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20080414175158.5db84dcd@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080412205544.5e12a7d4.akpm@linux-foundation.org>
	 <20080414091639.4bd3879d@core> <20080414084141.GA29113@infradead.org>
	 <200804141020.37271.chris.mason@oracle.com>
	 <b6c5339f0804140936s3dcce48en59a270dc86bf7dc8@mail.gmail.com>
	 <20080414175158.5db84dcd@core>
X-Google-Sender-Auth: 62b9eb4fe6610f7e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 12:51 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>
>  What does the replaytv byteswap - the entire blocks or some fields ?

Entire blocks (both meta- and normal data).  E.g. the filename 'Filename'
would look like 'eliFeman' on disk.  I have a dm target that can do this
gathering dust somewhere.

-- 
Bob Copeland %% www.bobcopeland.com
